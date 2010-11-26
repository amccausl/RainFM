
import Text.XML.HXT.Core
import Text.XML.HXT.Arrow.XmlState.SystemConfig
import Text.XML.HXT.Curl
import Text.XML.HXT.TagSoup

import Control.Arrow.ArrowList
import Data.Time
import Data.Char
import Locale

tagsoupLoadConfig = [ withParseHTML     yes
                    , withTagSoup
                    , withCurl          [("user-agent", "Mozilla/5.0 (en-US) Firefox/2.0.0.6667")]
                    , withWarnings      no
                    ]

play = runX (readDocument tagsoupLoadConfig "http://microformats.org/wiki/hcard" >>> getVCard)

getVCard :: (ArrowXml a) => a XmlTree (String, String)
getVCard = deep (hasAttrValue "class" (elem "vcard" . words))
    >>>     (constA "fn" &&& (deep (hasAttrValue "class" (elem "fn" . words)) >>> getTrimedText))
        <+> (constA "email" &&& (deep (hasAttrValue "class" (elem "email" . words)) >>> getTrimedText))
        <+> (constA "url" &&& (deep (hasAttrValue "class" (elem "url" . words)) >>> getHref))

getTrimedText :: (ArrowXml a) => a XmlTree String
getTrimedText = deep isText >>> getText >>> arr (dropWhile isSpace . reverse . dropWhile isSpace . reverse)

getHref :: (ArrowXml a) => a XmlTree String
getHref = deep (hasAttrValue "href" (not . Prelude.null)) >>> getAttrValue "href"
