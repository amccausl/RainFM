
import Text.XML.HXT.Core
import Text.XML.HXT.Arrow.XmlState.SystemConfig
import Text.XML.HXT.Curl
import Text.XML.HXT.TagSoup

import Control.Arrow.ArrowList
import Data.Char
import Data.Time
import Data.RDF
import Locale

tagsoupLoadConfig = [ withParseHTML     yes
                    , withTagSoup
                    , withWarnings      no
                    ]

play = runX (readDocument tagsoupLoadConfig "http://microformats.org/wiki/hcard" >>> getVCard)

getVCard :: (ArrowXml a) => a XmlTree (String, String)
getVCard = getClassType "vcard"
    >>>     (constA "fn" &&& (getClassType "fn" >>> getTrimedText))
        <+> (constA "email" &&& (getClassType "email" >>> getTrimedText))
        <+> (constA "url" &&& (getClassType "url" >>> getHref))

getClassType :: (ArrowXml a) => String -> a XmlTree XmlTree
getClassType tag = deep (hasAttrValue "class" (elem tag . words))

getTrimedText :: (ArrowXml a) => a XmlTree String
getTrimedText = deep isText >>> getText >>> arr (dropWhile isSpace . reverse . dropWhile isSpace . reverse)

getHref :: (ArrowXml a) => a XmlTree String
getHref = deep (hasAttrValue "href" (not . Prelude.null)) >>> getAttrValue "href"
