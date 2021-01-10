module App where

import Prelude
import Control.Plus (empty)
import Data.Array as Array
import Data.Tuple.Nested ((/\))
import Data.Newtype (wrap)
import Effect.Aff (delay, launchAff_)
import Effect.Class (liftEffect)
import Effect.Console (log)
import React.Basic.DOM (div_, h1_, li_, text, ul_)
import React.Basic.DOM.Events (preventDefault)
import React.Basic.Events (handler)
import React.Basic.Hooks (Component)
import React.Basic.Hooks as React
import React.Keybind (WithShortcutProps, shortcutConsumer, shortcutProvider_, withShortcut, shortcutId, shortcutTitle, shortcutDescription)

myComponent :: Component WithShortcutProps
myComponent = do
  React.component "MyComponent" \{ shortcut: {registerShortcut, unregisterShortcut, triggerShortcut} } -> React.do
    state /\ modifyState <- React.useState { isSaved: false, totalFiles: 0 }
    
    create <- React.useMemo ([] :: Array Unit) \_ -> do
      log $ "Creating file ..."
      modifyState \{ totalFiles } -> { isSaved: false, totalFiles: totalFiles + 1 }

    save <- React.useMemo ([] :: Array Unit) \_ -> launchAff_ do
      liftEffect $ log $ "Saving file ..."
      delay (wrap 1000.0)
      liftEffect $ modifyState \{ totalFiles } -> { isSaved: true, totalFiles }

    React.useEffectOnce do
      _ <- registerShortcut (handler preventDefault (const save)) ["ctrl+s", "cmd+s"] "Save" "Save a file" empty
      _ <- registerShortcut (handler preventDefault (const create)) ["ctrl+n", "cmd+n"] "New" "Create a new file" empty
      log "Registered shortcuts!"
      pure do
        _ <- unregisterShortcut ["ctrl+s", "cmd+s"]
        _ <- unregisterShortcut ["ctrl+n", "cmd+n"]
        log "Unregistered shortcuts!"

    pure $ div_ $
      [ div_ [text "Save the file with Ctrl + S"]
      , div_ [text $ "File status: " <> if state.isSaved then "Saved" else "Not Saved"]
      , div_ [text $ "Total Files: " <> show state.totalFiles]
      ]

myShortcutComponent :: Component {}
myShortcutComponent = withShortcut "MyShortcutComponent" myComponent

mkApp :: Component Unit
mkApp = do
  shortcutComponent <- myShortcutComponent
  React.component "MyApp" \_ -> do
    pure $ shortcutProvider_ $
      [ shortcutComponent {}
      , shortcutConsumer \{ shortcuts } -> Array.singleton $ div_
        [ h1_ [text "Available Keys"]
        , ul_ $ shortcuts <#> \binding ->
            React.keyed (shortcutId binding) $
              li_ [text $ shortcutTitle binding <> " - " <> show (shortcutDescription binding)]
        ]
      ]
