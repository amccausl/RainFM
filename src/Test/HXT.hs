{-# LANGUAGE Arrows, NoMonomorphismRestriction #-}
import Text.XML.HXT.Arrow

module Main (main) where

main = do
         conn <- TCP.openStream "localhost" 80
         print (rqBody updateTest)
         rawResponse <- sendHTTP conn updateTest
         body <- getResponseBody rawResponse
         if body == rqBody updateTest
           then print "test passed"
           else print (body ++ " != " ++ (rqBody updateTest))

updateURI = case parseURI "http://localhost/test.php" of
                  Just u -> u

updateTest = Request { rqURI = updateURI :: URI
                     , rqMethod = POST :: RequestMethod
                     , rqHeaders = [ Header HdrContentType   "text/plain; charset=utf-8"
                                   , Header HdrContentLength "11" ] :: [Header]
                     , rqBody = "Test string"
                     }
