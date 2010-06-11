--module RainFM.Test.Http (main) where
module Main (main) where

import Network.HTTP

main = do
       print p
       string <- (simpleHTTP p >>= fmap (take 100) . getResponseBody)
       print string
  where p = postRequest "http://localhost/test.php?val=var"
