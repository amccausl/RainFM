{-# LANGUAGE Arrows, NoMonomorphismRestriction #-}
module Main (main) where
--module Network.Search.Solr.TestXML
--       ( test_ResultToDoc
--       ) where

import Text.XML.HXT.Arrow
import Network.Search.Solr.Data
import Data.DateTime
import Data.UUID

testId :: UUID
testId = case fromString "008d7409-edf5-4d82-9e2c-1035a0527066" of
           Just uuid -> uuid

test1Xml :: String
test1Xml = "<doc>"
  ++ "<str name=\"id\">" ++ toString testId ++ "</str>" 
  ++ "<str name=\"description\">electronics</str>"
--  ++ "<date name=\"updated\">2006-02-15T23:55:59Z</date>"
  ++ "<arr name=\"tag\"><str>tag1</str><str>tag3</str></arr>"
  ++ "</doc>"

test1Doc :: SolrDoc
test1Doc = [ ("id", SolrId testId)
           , ("description", SolrStr "electronics")
--           , ("updated", SolrDate
           , ("tag", SolrArr [SolrStr "tag1", SolrStr "tag3"])
           ]
           
getDoc = deep (isElem >>> hasName "doc") >>> getChildren >>>
   proc x -> do
     strs <- deep (isElem >>> hasName "str") -< x
     strName <- getAttrValue "name" -< strs
     strContent <- getText <<< getChildren -< strs
     --arrs <- deep (isElem >>> hasName "arr") -< x
     --arrName <- getAttrValue "name" -< arrs
     --arrContent <- getText <<< getChildren <<< getChildren -< arrs
     returnA -< (strName, tryUUID strContent)--, arrName, arrContent)

getDrop1 = deep (isElem >>> hasName "doc") >>>
   proc x -> do
     strs <- getText <<< getChildren <<< deep (hasName "arr") -< x
     str1 <- getAttrValue "name" <<< deep (hasName "arr") -< x
     returnA -< (str1, strs)

getDrop = deep (isElem >>> hasName "arr") >>>
   proc x -> do
     strs <- getText <<< getChildren <<< getChildren -< x
     str1 <- getAttrValue "name" -< x
     returnA -< (str1, SolrStr strs)

getPair = deep (isElem >>> hasName "str") >>>
   proc x -> do
     strs <- getText <<< getChildren -< x
     str1 <- getAttrValue "name" -< x
     returnA -< (str1, strs)

getDrop2 = deep (isElem >>> hasName "str") >>>
   proc x -> do
     strs <- getText <<< getChildren -< x
     str1 <- getAttrValue "name" -< x
     returnA -< (str1, tryUUID strs)

tryUUID str = case fromString str of
                Just uuid -> SolrId uuid
                Nothing -> SolrStr str

main = do
       result2 <- (runX (readString [(a_validate,v_0)] test1Xml >>> getDrop1))
       print "result2:"
       print result2
       result3 <- (runX (readString [(a_validate,v_0)] test1Xml >>> getPair))
       print "result3:"
       print result3
       result4 <- (runX (readString [(a_validate,v_0)] test1Xml >>> getDrop))
       putStrLn "result4:"
       print result4
       result5 <- (runX (readString [(a_validate,v_0)] test1Xml >>> getDrop2))
       putStrLn "result5:"
       print result5
       result6 <- (runX (readString [(a_validate,v_0)] test1Xml >>> getDoc))
       putStrLn "result6:"
       print result6
    