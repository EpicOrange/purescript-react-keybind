-- | This module provides bindings for the components provided
-- | by the `react-keybind` library, intended to be used in the
-- | same fashion as [React.Basic.DOM](https://pursuit.purescript.org/search?q=React.Basic.DOM).
-- | 
-- | Quick usage guide for the components
-- | `shortcutProvider`, `shortcutConsumer`, and `withShortcut`:
-- | ```
-- | shortcutProvider { children: [], ignoreKeys: ["shift", "ctrl"] } [ ... ]
-- |
-- | shortcutConsumer \{ registerShortcut, shortcuts } -> [ ... ]
-- |
-- | myShortcutComponent :: Component {}
-- | myShortcutComponent = withShortcut "MyShortcutComponent" $
-- |   React.component "MyComponent" \{ shortcut: {registerShortcut, unregisterShortcut} } -> React.do
-- |   ...
-- | ```
-- |
-- | Quick guide to `registerShortcut`:
-- | ```
-- |  _ <- registerShortcut { method: handler_ save
-- |                        , keys: ["ctrl+s", "cmd+s"]
-- |                        , title: "Save"
-- |                        , description: "Save a file"
-- |                        , holdDuration: Nothing }
-- | ```
-- |   
-- | Every key in `keys` gets bound to the given `method` handler.
-- | The strings are checked (case-insensitive) against `KeyboardEvent.key`,
-- | and may be modified with `ctrl`, `alt`, `meta`/`cmd`, and `shift`.
-- | 
-- | For further guidance, check out the `examples` directory in the git repo!

module React.Keybind
  ( shortcutConsumer
  , shortcutProvider
  , shortcutProvider_
  , withShortcut
  ) where

import Prelude (bind, identity, pure, ($), (<<<))
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Uncurried (runEffectFn1)
import React.Basic (JSX, ReactComponent, element)
import React.Basic.Classic (createComponent, toReactComponent)
import React.Keybind.Internal (ProviderRenderProps', shortcutConsumerImpl, shortcutProvider', transformProviderProps, withShortcut')
import React.Keybind.Types (ProviderPropsRow, ProviderRenderProps, WithShortcutPropsRow)
import Record (modify) as Record
import Prim.Row (class Union)

-- | Create a shortcut provider with possible props:
-- | ```
-- | children       :: Array JSX
-- | ignoreKeys     :: Array String
-- | ignoreTagNames :: Array String
-- | preventDefault :: Boolean
-- | ```
shortcutProvider
  :: forall props props_
   . Union props props_ ProviderPropsRow
  => Record props
  -> JSX
shortcutProvider = element shortcutProvider'

-- | Shorthand of `shortcutProvider` for only passing in children
shortcutProvider_ :: Array JSX -> JSX
shortcutProvider_ children = shortcutProvider { children }

-- | Create a shortcut consumer that offers the following props:
-- | ```
-- | registerShortcut         :: ShortcutSpec -> Effect Unit
-- | registerSequenceShortcut :: ShortcutSpec -> Effect Unit
-- | shortcuts                :: Array IShortcut
-- | triggerShortcut          :: String -> Effect Unit
-- | unregisterShortcut       :: Array String -> Effect Unit
-- | ```
-- | 
-- | Usage: 
-- | shortcutConsumer \{ registerShortcut, shortcuts } -> [ ... ]
shortcutConsumer :: (ProviderRenderProps -> Array JSX) -> JSX
shortcutConsumer mkChildren = element shortcutConsumerImpl { children: mkChildren <<< transformProviderProps }

-- | Equal to React.Basic.Hooks.Component.
-- | Redefined here to avoid having all of Hooks as a dependency just for one type.
type Component props = Effect (props → JSX)

-- | A higher-order pure component that adds a single prop `shortcut` containing:
-- | ```
-- | registerShortcut         :: ShortcutSpec -> Effect Unit
-- | registerSequenceShortcut :: ShortcutSpec -> Effect Unit
-- | shortcuts                :: Array IShortcut
-- | triggerShortcut          :: String -> Effect Unit
-- | unregisterShortcut       :: Array String -> Effect Unit
-- | ```
-- |
-- | Use this with (or as an alternative to) `shortcutConsumer`.
withShortcut
  :: forall props props_
   . Union WithShortcutPropsRow props props_
  => String
  -> Component { shortcut :: ProviderRenderProps | props }
  -> Component { | props }
withShortcut name child = do
  render <- child
  let mapShortcut :: { shortcut :: ProviderRenderProps' | props } -> { shortcut :: ProviderRenderProps | props }
      mapShortcut = Record.modify (SProxy :: SProxy "shortcut") transformProviderProps
  let wrappedProps = { render: render <<< mapShortcut <<< _.props }
  let wrapped = toReactComponent identity (createComponent name) wrappedProps
        :: ReactComponent { shortcut :: ProviderRenderProps' | props }
  wrapped' <- runEffectFn1 withShortcut' wrapped :: Effect (ReactComponent { | props })
  pure $ element wrapped'
