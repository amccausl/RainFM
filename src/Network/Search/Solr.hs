module Network.Search.Solr
       ( SolrInstance(..)
       , sendRequest
--       , query
--       , add
--       , update
--       , delete
       , commit
       , optimize
       ) where

import Network.URI (URI (..), parseURI, uriScheme, uriPath, uriQuery, uriFragment)
import Network.TCP as TCP
import Network.HTTP
--import Network.Search.Data
import Network.HTTP
import Data.UUID

data SolrInstance a =
     SolrInstance { solrHost :: String
                  , solrPort :: Int
--                  , toXML :: a -> String
--                  , fromXML :: String -> a
                  }

getUpdateURI :: SolrInstance a -> URI
getUpdateURI solr = case parseURI ("http://" ++ (solrHost solr) ++ ":" ++ (show (solrPort solr)) ++ "/solr/update") of
                        Just u -> u

getQueryURI :: SolrInstance a -> URI
getQueryURI solr = case parseURI ("http://" ++ (solrHost solr) ++ ":" ++ (show (solrPort solr)) ++ "/solr/select") of
                        Just u -> u


--query :: SolrInstance a -> [QueryParameter] -> IO ([a])
--query_ :: 

--add :: SolrInstance a -> UUID -> [a] -> IO (String)
-- pickle [a] -> xml -> add to <add> tag, post

--update :: SolrInstance a -> UUID -> [a] -> IO (String)

--delete :: SolrInstance a -> [QueryParameter] -> IO (String)

commit :: SolrInstance a -> IO (String)
commit solr = sendRequest solr "<commit/>"

optimize :: SolrInstance a -> IO (String)
optimize solr = sendRequest solr "<optimize/>"

sendRequest :: SolrInstance a -> String -> IO (String)
sendRequest solr msg = do
                         conn <- TCP.openStream (solrHost solr) (solrPort solr)
                         print (rqBody req)
                         rawResponse <- sendHTTP conn req
                         body <- getResponseBody rawResponse
                         return body
                         --case rawResponse of
                         --   Right response -> return response
                         --   Left error -> return error
        where req = solrRequest solr msg

--solrRequest :: SolrInstance a -> String -> Request
solrRequest solr msg = Request { rqURI = getUpdateURI solr :: URI
                               , rqMethod = POST :: RequestMethod
                               , rqHeaders = [ Header HdrContentType   "text/xml; charset=utf-8"
                                             , Header HdrContentLength (show (length msg))
                                             ] :: [Header]
                               , rqBody = msg
                               --, rqBody = encodeUtf8 (pack testPost)
                               --, rqBody = Binary.encode (UTF8Bin.encode testPost)
                               }

--solrCommitTest = solrUpdateTest{ rqBody = Binary.encode (UTF8Bin.encode testPost2) }

