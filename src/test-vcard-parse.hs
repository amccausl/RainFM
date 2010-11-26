
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

play = runX (readDocument tagsoupLoadConfig "http://microformats.org/wiki/hcard" >>> getMicroformat)

trimWhiteSpace :: String -> String
trimWhiteSpace = dropWhile isSpace . reverse . dropWhile isSpace . reverse

getMicroformat = deep (hasAttrValue "class" (elem "vcard" . words))
    >>> putXmlTree "-"
    >>> (constA "fn" &&& (deep (hasAttrValue "class" (elem "fn" . words)) >>> deep isText >>> getText >>> arr trimWhiteSpace))
    <+> (constA "email" &&& (deep (hasAttrValue "class" (elem "email" . words)) >>> deep isText >>> getText >>> arr trimWhiteSpace))
    <+> (constA "url" &&& (deep (hasAttrValue "class" (elem "url" . words)) >>> deep (hasAttrValue "href" (not . null)) >>> getAttrValue "href"))
