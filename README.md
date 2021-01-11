# purescript-react-keybind

[![Pursuit](https://pursuit.purescript.org/packages/purescript-react-keybind/badge)](https://pursuit.purescript.org/packages/purescript-react-keybind)

This library provides Purescript bindings for [this library of the same name](https://github.com/UnicornHeartClub/react-keybind).

The majority of documentation can be found [here](https://pursuit.purescript.org/packages/purescript-react-keybind). There is also an example in `examples/` that can be built by running:

```
npm i
npm run serve-example
```

## Installation

Add the following to `additions` in your `packages.dhall`:

```
let additions =
      { tree =
        { dependencies =
            [ "react-basic"
            , "react-basic-classic"
            , "undefined-or"
            ]
        , repo = "https://github.com/EpicOrange/purescript-react-keybind"
        , version = "v0.8.1"
        }
      }
```

Then run:

```
spago install react-keybind
```

## Documentation

Module documentation is [published on Pursuit](https://pursuit.purescript.org/packages/purescript-react-keybind).
