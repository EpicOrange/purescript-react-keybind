-- | This module contains Purescript versions of types in
-- | the original `react-keybind` library.
-- | 
-- | Although all types are exported, `ShortcutSpec` and `WithShortcutProps`
-- | are likely the only two types you'll need from here. For example:
-- |
-- | ```
-- | myWrappedComponent :: Component WithShortcutProps
-- | ```
-- | 
-- | ```
-- | let myShortcut :: ShortcutSpec
-- |     myShortcut = { method: handler_ doSomething, keys: ["ctrl+h", "cmd+h"], ... }
-- | ```

module React.Keybind.Types
  ( ShortcutSpec
  , ShortcutSpecRow
  , WithShortcutProps
  , WithShortcutPropsRow
  , ProviderProps
  , ProviderPropsRow
  , IShortcut
  , ProviderRenderProps
  , ProviderRenderPropsRow
  ) where

import Prelude
import Data.Maybe (Maybe)
import Effect (Effect)
import React.Basic (JSX)
import React.Basic.Events (EventHandler)

type WithShortcutProps = Record WithShortcutPropsRow
type WithShortcutPropsRow = ( shortcut :: ProviderRenderProps )

type ShortcutSpec = Record ShortcutSpecRow
type ShortcutSpecRow =
  ( method       :: EventHandler
  , keys         :: Array String
  , title        :: String
  , description  :: String
  , holdDuration :: Maybe Number
  )

type ProviderProps = Record ProviderPropsRow
type ProviderPropsRow =
  ( children       :: Array JSX
  , ignoreKeys     :: Array String
  , ignoreTagNames :: Array String
  , preventDefault :: Boolean
  )

type IShortcut =
  { id           :: String
  , description  :: String
  , hold         :: Number
  , holdDuration :: String
  , keys         :: Array String
  , method       :: EventHandler
  , sequence     :: Boolean
  , title        :: String
  }

type ProviderRenderProps = Record ProviderRenderPropsRow
type ProviderRenderPropsRow =
  ( registerShortcut         :: ShortcutSpec -> Effect Unit
  , registerSequenceShortcut :: ShortcutSpec -> Effect Unit
  , shortcuts                :: Array IShortcut
  , triggerShortcut          :: String -> Effect Unit
  , unregisterShortcut       :: Array String -> Effect Unit
  )
