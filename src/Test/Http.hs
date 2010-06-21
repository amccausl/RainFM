--module RainFM.Test.Http (main) where
module Main (main) where

import Network.URI (URI (..), parseURI, uriScheme, uriPath, uriQuery, uriFragment)
import Network.HTTP
import Data.String.UTF8 as UTF8
import Codec.Binary.UTF8.String as UTF8Bin
import Char
import Network.TCP as TCP
import Data.Binary as Binary
import Data.Text
import Data.Text.Encoding

main = do
       --print (show testURI2)
       --print (show (uriScheme testURI2))
       --print (show (uriPath testURI2))
       --print (show (uriQuery testURI2))
       --print (show (uriFragment testURI2))
       --string <- (simpleHTTP solrUpdateTest >>= fmap (take 100) . getResponseBody)
       print "solr update"
       sendRequest solrUpdateTest
       --string <- (simpleHTTP solrUpdateTest >>= getResponseBody)
       --putStrLn (show string)
       print "solr commit"
       --string2 <- (simpleHTTP solrCommitTest >>= getResponseBody)
       --putStrLn (show string2)
       --sendRequest solrCommitTest
       --putStrLn (show response)

sendRequest req = do
                  conn <- TCP.openStream "localhost" 80
                  print (rqBody req)
                  rawResponse <- sendHTTP conn req
                  body <- getResponseBody rawResponse
                  print body
                  case rawResponse of
                    Right response -> print response
                    Left error -> print error

--solrUpdateURI = case parseURI "http://localhost:8080/solr/update" of
solrUpdateURI = case parseURI "http://localhost/test.php" of
                    Just u -> u

solrUpdateTest = Request { rqURI = solrUpdateURI :: URI
                         , rqMethod = POST :: RequestMethod
                         , rqHeaders = [ Header HdrContentType   "text/xml; charset=utf-8"
                                       ] :: [Header]
                         , rqBody = encodeUtf8 (pack testPost)
                         --, rqBody = Binary.encode (UTF8Bin.encode testPost)
                         }

solrCommitTest = solrUpdateTest{ rqBody = Binary.encode (UTF8Bin.encode testPost2) }


testPost = "<add>"
    ++ "<doc>"
    ++   "<field name='source'>http://localhost</field>"
    ++   "<field name='subject'>Haskell Post Test</field>"
    ++   "<field name='description'>Haskell record updater is working</field>"
    ++   "<field name='tag'>tag3</field>"
    ++   "<field name='tag'>tag4</field>"
    ++   "<field name='access_timestamp'>2006-02-14T23:55:59Z</field>"
    ++   "<field name='access_thread'>1</field>"
    ++   "<field name='access_parent'>0</field>"
    ++ "</doc>"
    ++ "<doc>"
    ++   "<field name='source'>http://localhost</field>"
    ++   "<field name='subject'>Haskell Post Test</field>"
    ++   "<field name='description'>Haskell record updater is working</field>"
    ++   "<field name='tag'>tag3</field>"
    ++   "<field name='tag'>tag4</field>"
    ++   "<field name='access_timestamp'>2006-02-14T23:55:59Z</field>"
    ++   "<field name='access_thread'>1</field>"
    ++   "<field name='access_parent'>0</field>"
    ++ "</doc>"
    ++ "</add>"

testPost2 = "<commit/>"
