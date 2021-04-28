{ name = "react-keybind-example"
, dependencies =
  [ "aff"
  , "arrays"
  , "console"
  , "effect"
  , "exceptions"
  , "maybe"
  , "newtype"
  , "prelude"
  , "react-basic"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "react-keybind"
  , "tuples"
  , "web-dom"
  , "web-html"
  ]
, packages = ./packages.dhall with react-keybind = ./spago.dhall as Location
, sources = [ "example/**/*.purs" ]
}
