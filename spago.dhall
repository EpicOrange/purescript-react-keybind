{-
Welcome to a Spago project!
You can edit this file as you like.
-}
{ name = "react-keybind"
, dependencies =
  [ "aff"
  , "console"
  , "effect"
  , "psci-support"
  , "react-basic"
  , "react-basic-classic"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "undefined-or"
  , "web-dom"
  , "web-html"
  ]
, packages = ./packages.dhall
, sources = [ "src/**/*.purs", "test/**/*.purs" ]
}
