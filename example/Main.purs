module Main where

import Prelude
import App (mkApp) as App
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Exception (throw)
import React.Basic.DOM (render)
import Web.DOM.NonElementParentNode (getElementById)
import Web.HTML (window)
import Web.HTML.HTMLDocument (toNonElementParentNode)
import Web.HTML.Window (document)

main :: Effect Unit
main = do
  root <- getElementById "root" =<< (map toNonElementParentNode $ document =<< window)
  app <- App.mkApp
  case root of
    Nothing -> throw "Root element not found."
    Just r  -> render (app unit) r
