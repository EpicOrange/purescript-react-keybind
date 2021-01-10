{ name = "react-keybind-example"
, dependencies =
  [ "aff"
  , "console"
  , "react-basic"
  , "react-basic-dom"
  , "react-basic-hooks"
  , "react-keybind"
  , "web-dom"
  , "web-html"
  ]
, packages = ./packages.dhall
    with react-keybind = ./spago.dhall as Location
, sources = [ "example/**/*.purs" ]
}
