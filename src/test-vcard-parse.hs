
import Text.XML.HXT.Core
import Text.XML.HXT.Arrow.XmlState.SystemConfig
import Text.XML.HXT.Curl
import Text.XML.HXT.TagSoup

import Control.Arrow.ArrowList
import Data.Time
import Data.UUID
import Locale

tagsoupLoadConfig = [ withParseHTML     yes
                    , withTagSoup
                    , withCurl          [("user-agent", "Mozilla/5.0 (en-US) Firefox/2.0.0.6667")]
                    , withWarnings      no
                    ]

play = runX (readDocument tagsoupLoadConfig "http://microformats.org/wiki/hcard" >>> getMicroformat >>> putXmlTree "-")

getMicroformat = deep (hasAttrValue "class" (elem "vcard" . words))

