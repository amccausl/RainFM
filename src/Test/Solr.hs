module Main (main) where

import Network.Search.Solr
import Data.UUID

main = do
        resp1 <- sendRequest testSolr testPost
        print resp1
        resp2 <- commit testSolr
        print resp2

testSolr = SolrInstance { solrHost = "localhost"
                        , solrPort = 8080
                        }

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
    ++   "<field name='subject'>Haskell Post Test2</field>"
    ++   "<field name='description'>WOOT</field>"
    ++   "<field name='tag'>tag3</field>"
    ++   "<field name='tag'>tag4</field>"
    ++   "<field name='access_timestamp'>2006-02-14T23:55:59Z</field>"
    ++   "<field name='access_thread'>1</field>"
    ++   "<field name='access_parent'>0</field>"
    ++ "</doc>"
    ++ "</add>"
