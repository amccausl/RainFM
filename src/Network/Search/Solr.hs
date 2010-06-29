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

-- Constants
requestSize = 100  -- Do operations in groups of 100

data SolrInstance a =
     SolrInstance { solrHost :: String
                  , solrPort :: Int
                  , solrImport :: a -> SolrDoc
                  , solrExport :: SolrDoc -> a
                  }
  deriving (Eq, Show)

data SolrData = SolrId UUID
              | SolrInt Int
              | SolrStr String
              | SolrDate DateTime
              | SolrArr [SolrElem]
   deriving (Eq, Show)

type SolrDoc = [(String, SolrData)]

data SolrResult = SolrResult { resultName :: String
                             , resultCount :: Int
                             , resultScore :: Float
                             , resultDocs :: [SolrDoc]
                             }
  deriving (Eq, Show)

getUpdateURI :: SolrInstance a -> URI
getUpdateURI solr = case parseURI ("http://" ++ (solrHost solr) ++ ":" ++ (show (solrPort solr)) ++ "/solr/update") of
                        Just u -> u

getQueryURI :: SolrInstance a -> URI
getQueryURI solr = case parseURI ("http://" ++ (solrHost solr) ++ ":" ++ (show (solrPort solr)) ++ "/solr/select") of
                        Just u -> u


--query :: SolrInstance a -> [QueryParameter] -> IO ([a])
--query_ :: 

--add :: SolrInstance a -> [a] -> IO (String)
-- pickle [a] -> xml -> add to <add> tag, post

--update :: SolrInstance a -> UUID -> [a] -> IO (String)

--delete :: SolrInstance a -> [QueryParameter] -> IO (String)

--deleteByID :: solrInstance a -> UUID -> IO (String)

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
                               }

