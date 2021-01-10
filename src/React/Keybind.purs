module React.Keybind
  ( shortcutConsumer
  , shortcutProvider
  , shortcutProvider_
  , ProviderRenderProps
  , ProviderRenderPropsRow
  , WithShortcutProps
  , WithShortcutPropsRow
  , withShortcut
  , withShortcut'
  , IShortcut
  , shortcutId
  , shortcutDescription
  , shortcutHold
  , shortcutHoldDuration
  , shortcutKeys
  , shortcutSequence
  , shortcutTitle
  ) where

import Prelude
import Data.UndefinedOr (UndefinedOr)
import Data.Symbol (SProxy(..))
import Effect (Effect)
import Effect.Uncurried (EffectFn1, EffectFn4, EffectFn5, runEffectFn1, runEffectFn4, runEffectFn5)
import React.Basic (JSX, ReactComponent, element)
import React.Basic.Classic (createComponent, toReactComponent)
import React.Basic.Events (EventHandler)
import Record (modify) as Record
import Prim.Row (class Union)
import Unsafe.Coerce (unsafeCoerce)

-- withShortcut

withShortcut ::
  forall props shortcut.
  Union WithShortcutPropsRow props shortcut =>
  String ->
  Effect ({ shortcut :: ProviderRenderProps | props } -> JSX) ->
  Effect ({ | props } -> JSX)
withShortcut name child = do
  render <- child
  let componentProps = { render: render <<< Record.modify (SProxy :: SProxy "shortcut") transformProviderProps <<< _.props }
  let component = toReactComponent identity (createComponent name) componentProps
        :: ReactComponent { shortcut :: ProviderRenderProps' | props }
  component' <- withShortcut' (pure component) :: Effect (ReactComponent { | props })
  pure $ element component'

withShortcut'
  :: forall props shortcut
   . Union WithShortcutPropsRow' props shortcut
  => Effect (ReactComponent { shortcut :: ProviderRenderProps' | props })
  -> Effect (ReactComponent { | props })
withShortcut' = (_ >>= runEffectFn1 withShortcut'')

withShortcut''
  :: forall props shortcut
   . Union WithShortcutPropsRow' props shortcut
  => EffectFn1 (ReactComponent { | shortcut }) (ReactComponent { | props })
withShortcut'' = unsafeCoerce withShortcutImpl

type WithShortcutProps = Record WithShortcutPropsRow
type WithShortcutPropsRow = ( shortcut :: ProviderRenderProps )
type WithShortcutProps' = Record WithShortcutPropsRow'
type WithShortcutPropsRow' = ( shortcut :: ProviderRenderProps' )



-- consumer 

type ProviderRenderProps = Record ProviderRenderPropsRow
type ProviderRenderPropsRow =
  ( registerShortcut :: EventHandler {- method -}
                     -> (Array String) {- keys -}
                     -> String {- title -}
                     -> String {- description -}
                     -> UndefinedOr Number {- holdDuration -}
                     -> Effect Unit
  , registerSequenceShortcut :: EventHandler {- method -}
                             -> (Array String) {- keys -}
                             -> String {- title -}
                             -> String {- description -}
                             -> Effect Unit
  , shortcuts :: Array IShortcut
  , triggerShortcut :: String -> Effect Unit
  , unregisterShortcut :: Array String -> Effect Unit
  )

type ProviderRenderProps' = Record ProviderRenderPropsRow'
type ProviderRenderPropsRow' =
  ( registerShortcut :: EffectFn5 EventHandler {- method -}
                                  (Array String) {- keys -}
                                  String {- title -}
                                  String {- description -}
                                  -- for this, provide Control.Plus.empty or (pure 7.5)
                                  (UndefinedOr Number) {- holdDuration -}
                                  Unit
  , registerSequenceShortcut :: EffectFn4 EventHandler {- method -}
                                          (Array String) {- keys -}
                                          String {- title -}
                                          String {- description -}
                                          Unit
  , shortcuts :: Array IShortcut
  , triggerShortcut :: EffectFn1 String Unit
  , unregisterShortcut :: EffectFn1 (Array String) Unit
  )

transformProviderProps :: ProviderRenderProps' -> ProviderRenderProps
transformProviderProps {registerShortcut, registerSequenceShortcut, shortcuts, triggerShortcut, unregisterShortcut} =
  { registerShortcut: runEffectFn5 registerShortcut
  , registerSequenceShortcut: runEffectFn4 registerSequenceShortcut
  , shortcuts
  , triggerShortcut: runEffectFn1 triggerShortcut
  , unregisterShortcut: runEffectFn1 unregisterShortcut
  }

shortcutConsumer :: (ProviderRenderProps -> Array JSX) -> JSX
shortcutConsumer mkChildren = element shortcutConsumerImpl { children: mkChildren <<< transformProviderProps }



-- provider

type ProviderProps = Record ProviderPropsRow
type ProviderPropsRow =
  ( children :: Array JSX
  , ignoreKeys :: Array String
  , ignoreTagNames :: Array String
  , preventDefault :: Boolean
  )

shortcutProvider
  :: forall props props_
   . Union props props_ ProviderPropsRow
  => Record props
  -> JSX
shortcutProvider = element shortcutProvider'

shortcutProvider_ :: Array JSX -> JSX
shortcutProvider_ children = shortcutProvider { children }

shortcutProvider'
  :: forall props props_
   . Union props props_ ProviderPropsRow
  => ReactComponent (Record props)
shortcutProvider' = unsafeCoerce shortcutProviderImpl

-- implementations

foreign import data IShortcut :: Type
foreign import shortcutId           :: IShortcut -> String
foreign import shortcutDescription  :: IShortcut -> Boolean
foreign import shortcutHold         :: IShortcut -> Number
foreign import shortcutHoldDuration :: IShortcut -> String
foreign import shortcutKeys         :: IShortcut -> Array String
foreign import shortcutSequence     :: IShortcut -> Boolean
foreign import shortcutTitle        :: IShortcut -> String

foreign import shortcutConsumerImpl :: ReactComponent { children :: ProviderRenderProps' -> Array JSX }
foreign import shortcutProviderImpl :: ReactComponent ProviderProps
foreign import withShortcutImpl :: forall props props_. EffectFn1 (ReactComponent props) (ReactComponent props_)
