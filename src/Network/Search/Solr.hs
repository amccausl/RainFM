
module Network.Search.Solr
       ( query
       , add
       , update
       , delete
       , commit
       , optimize
       ) where

import Network.Search.Solr.Data
import Network.HTTP
import Data.UUID

data SolrInstance a =
     SolrInstance { host :: String
                  , port :: Int
                  , toXML :: a -> String
                  , fromXML :: String -> a
                  }


query :: SolrInstance -> [QueryParameter] -> IO ([a])
add :: SolrInstance -> UUID -> a -> IO ()
update :: SolrInstance -> UUID -> a -> IO ()
delete :: SolrInstance -> UUID -> IO ()
commit :: SolrInstance -> IO ()
optimize :: SolrInstance -> IO ()
