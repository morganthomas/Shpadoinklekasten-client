{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TypeApplications  #-}


module Main where


import           Shpadoinkle
import           Shpadoinkle.Backend.ParDiff
import           Shpadoinkle.Html
import           Shpadoinkle.Router

import           Types
import           View


main :: IO ()
main = runJSorWarp 8080 $
  fullPageSPA @SPA runApp runParDiff (\r -> initialModel r <$> getDatabase) view getBody (return . router) routes
