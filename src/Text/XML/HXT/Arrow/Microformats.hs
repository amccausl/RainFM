
module Text.XML.HXT.Arrow.Microformats
       ( Microformat(..)
       , getMicroformat
       ) where

import Text.XML.HXT.Core

-- Import shared data types
import Data.Time
--import Data.Listing
--import Data.Resume
--import Data.ICalendar
--import Data.VCard

--class Microformat t where
--    getMicroformat :: (ArrowXml a) => a XmlTree t

--instance Microformat Resume where
--    getMicroformat :: (ArrowXml a) => a XmlTree Resume

--instance Microformat Listing where
--    getMicroformat :: (ArrowXml a) => a XmlTree Listing

--instance Microformat VCard where
--    getMicroformat :: (ArrowXml a) => a XmlTree VCard
getMicroformat = deep (hasAttrValue "class" (elem "vcard" . words))

--instance Microformat ICalendar where
--    getMicroformat :: (ArrowXml a) => a XmlTree ICalendar

