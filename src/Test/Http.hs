--module RainFM.Test.Http (main) where
module Main (main) where

import Network.URI (URI (..), parseURI, uriScheme, uriPath, uriQuery, uriFragment)
import Network.HTTP

main = do
       print p
       print (show testURI)
       print (show (uriScheme testURI))
       print (show (uriPath testURI))
       print (show (uriQuery testURI))
       print (show (uriFragment testURI))
       print (show testURI2)
       print (show (uriScheme testURI2))
       print (show (uriPath testURI2))
       print (show (uriQuery testURI2))
       print (show (uriFragment testURI2))
       string <- (simpleHTTP p >>= fmap (take 100) . getResponseBody)
       print string
  where --p = postRequest "http://localhost/test.php?val=var"
        p = testRequest

testURI = URI { uriScheme = "http:"
              , uriAuthority = Nothing
              , uriPath = "/test.php"
              , uriQuery = "?var=val"
              , uriFragment = ""
              }
testURI2 = case parseURI "http://localhost/test.php?val=var" of
               Just u  -> u

testRequest = Request { rqURI = testURI2 :: URI
                      , rqMethod = POST :: RequestMethod
                      , rqHeaders = [ Header HdrContentLength (show (length "post contents here"))
                                    , Header HdrUserAgent     "test agent"
                                    ] :: [Header]
                      , rqBody = "post contents here" :: String
                      }

