# purescript-react-keybind

[![Pursuit](https://pursuit.purescript.org/packages/purescript-react-keybind/badge)](https://pursuit.purescript.org/packages/purescript-react-keybind)

This library provides Purescript bindings for [this library of the same name](https://github.com/UnicornHeartClub/react-keybind).

The majority of documentation can be found [on Pursuit](https://pursuit.purescript.org/packages/purescript-react-keybind). There is also an example app in `examples/` that can be built by running:

```
npm i
npm run serve-example
```

## Installation (with `spago`)

Since this package is not yet on [`package-sets`](https://github.com/purescript/package-sets), installation is not as easy as `spago install react-keybind`.

Add the following to `additions` in your `packages.dhall`:

```
let additions =
      { react-keybind =
        { dependencies =
            [ "effect"
            , "maybe"
            , "newtype"
            , "prelude"
            , "react-basic"
            , "react-basic-classic"
            , "record"
            , "unsafe-coerce"
            ]
        , repo = "https://github.com/EpicOrange/purescript-react-keybind"
        , version = "v0.9.4"
        }
      }
```

Then run:

```
spago install react-keybind
```

## Documentation

Module documentation is [published on Pursuit](https://pursuit.purescript.org/packages/purescript-react-keybind).
