module React.Keybind.Internal where

import Prelude (Unit, (<$>), (>>>))
import Data.Symbol (SProxy(..))
import Data.UndefinedOr (UndefinedOr, toUndefined)
import Effect (Effect)
import Effect.Uncurried (EffectFn1, runEffectFn1)
import Prim.Row (class Union)
import React.Basic (JSX, ReactComponent)
import React.Basic.Events (EventHandler, SyntheticEvent, handler, syntheticEvent)
import React.Keybind.Types (ProviderProps, ProviderPropsRow, ProviderRenderProps, ShortcutSpec)
import Record (modify) as Record
import Unsafe.Coerce (unsafeCoerce)

-- FFI

transformProviderProps :: ProviderRenderProps' -> ProviderRenderProps
transformProviderProps {registerShortcut, registerSequenceShortcut, shortcuts, triggerShortcut, unregisterShortcut} =
  { registerShortcut: unsafeApplyRegisterShortcut registerShortcut
  , registerSequenceShortcut: unsafeApplyRegisterSequenceShortcut registerSequenceShortcut
  , shortcuts: Record.modify (SProxy :: SProxy "method") toEventHandler <$> shortcuts
  , triggerShortcut: runEffectFn1 triggerShortcut
  , unregisterShortcut: runEffectFn1 unregisterShortcut
  }
  where
    toEventHandler :: EventHandler' -> EventHandler
    toEventHandler method = handler syntheticEvent (toUndefined >>> runEffectFn1 method)

shortcutProvider'
  :: forall props props_
   . Union props props_ ProviderPropsRow
  => ReactComponent (Record props)
shortcutProvider' = unsafeCoerce shortcutProviderImpl

withShortcut'
  :: forall props shortcut
   . Union WithShortcutPropsRow' props shortcut
  => EffectFn1 (ReactComponent { | shortcut }) (ReactComponent { | props })
withShortcut' = unsafeCoerce withShortcutImpl

-- (internal) implementations

foreign import shortcutConsumerImpl :: ReactComponent { children :: ProviderRenderProps' -> Array JSX }
foreign import shortcutProviderImpl :: ReactComponent ProviderProps
foreign import withShortcutImpl :: forall props props_. EffectFn1 (ReactComponent props) (ReactComponent props_)

foreign import unsafeApplyRegisterShortcut :: RegisterShortcutFnType -> ShortcutSpec -> Effect Unit
foreign import unsafeApplyRegisterSequenceShortcut :: RegisterSequenceShortcutFnType -> ShortcutSpec -> Effect Unit

-- (internal) foreign types

foreign import data RegisterShortcutFnType :: Type
foreign import data RegisterSequenceShortcutFnType :: Type
type EventHandler' = EffectFn1 (UndefinedOr SyntheticEvent) Unit
type IShortcut' =
  { id           :: String
  , description  :: String
  , hold         :: Number
  , holdDuration :: String
  , keys         :: Array String
  , method       :: EventHandler'
  , sequence     :: Boolean
  , title        :: String
  }
type ProviderRenderProps' = Record ProviderRenderPropsRow'
type ProviderRenderPropsRow' =
  ( registerShortcut         :: RegisterShortcutFnType
  , registerSequenceShortcut :: RegisterSequenceShortcutFnType
  , shortcuts                :: Array IShortcut'
  , triggerShortcut          :: EffectFn1 String Unit
  , unregisterShortcut       :: EffectFn1 (Array String) Unit
  )
type WithShortcutProps' = Record WithShortcutPropsRow'
type WithShortcutPropsRow' = ( shortcut :: ProviderRenderProps' )
