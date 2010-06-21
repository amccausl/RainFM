
module Network.Search.Solr
       ( SolrInstance(..)
       , query
       , add
       , update
       , delete
       , commit
       , optimize
       ) where

import Network.URI (URI (..), parseURI, uriScheme, uriPath, uriQuery, uriFragment)
import Network.TCP as TCP
import Network.HTTP
import Network.Search.Solr.Data
import Network.HTTP
import Data.UUID

data SolrInstance a =
     SolrInstance { host :: String
                  , port :: Int
                  , toXML :: a -> String
                  , fromXML :: String -> a
                  }

getUpdateURI :: SolrInstance a -> URI
getUpdateURI solr = case parseURI ("http://" ++ (host solr) ++ ":" ++ (show (port solr)) ++ "/solr/update")
                Just u -> u

getQueryURI :: SolrInstance a -> URI
getQueryURI solr = case parseURI ("http://" ++ (host solr) ++ ":" ++ (show (port solr)) ++ "/solr/select")
                Just u -> u


query :: SolrInstance a -> [QueryParameter] -> IO ([a])

add :: SolrInstance a -> UUID -> [a] -> IO (String)
-- pickle [a] -> xml -> add to <add> tag, post

update :: SolrInstance a -> UUID -> [a] -> IO (String)

delete :: SolrInstance a -> [QueryParameter] -> IO (String)

commit :: SolrInstance a -> IO (String)
commit solr = sendRequest solr "<commit/>"

optimize :: SolrInstance a -> IO (String)
commit solr = sendRequest solr "<optimize/>"

sendRequest :: SolrInstance a -> String -> IO (String)
sendRequest solr = do
                   conn <- TCP.openStream (host solr) (port solr)
                   print (rqBody req)
                   rawResponse <- sendHTTP conn req
                   body <- getResponseBody rawResponse
                   print body
                   case rawResponse of
                     Right response -> return response
                     Left error -> return error

solrRequest = Request { rqURI = solrUpdateURI :: URI
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
