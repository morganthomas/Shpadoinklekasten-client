{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications  #-}


module Main where


import           Data.Text
import           Language.Javascript.JSaddle (MonadJSM, liftJSM, eval)
import           Shpadoinkle
import           Shpadoinkle.Backend.ParDiff
import           Shpadoinkle.Html
import           Shpadoinkle.Html.LocalStorage
import           Shpadoinkle.Router

import           Types
import           View


initialState :: MonadJSM m => ZettelEditor m => Route -> m ViewModel
initialState r = do
  msid <- getStorage (LocalStorageKey "session")
  case msid of
    Just sid -> initialModel r <$> getDatabase sid
    Nothing -> do
      liftJSM $ eval ("window.localStorage.removeItem('session')" :: Text)
      return $ initialModel LoginRoute emptyZettel


main :: IO ()
main = runJSorWarp 8080 $
  fullPageSPA @SPA runApp runParDiff initialState view getBody (return . router) routes
