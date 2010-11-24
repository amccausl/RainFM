
module Data.Listing
       ( Listing(..)
       , ListingAction(..)
       ) where

import Data.Time
import Text.VCard.Types

data ListingAction = Sell
                   | Rent
                   | Trade
                   | Meet
                   | Announce
                   | Offer
                   | Wanted
                   | Event
                   | Service

data Listing = Listing { listingAction :: Maybe ListingAction
                       , listingLister :: VCard
                       , listingListed :: Maybe UTCTime
                       , listingExpired :: Maybe UTCTime
                       , listingPrice :: Maybe String
                       , listingInfo :: Maybe VCard
                       , listingSummary :: Maybe String
                       , listingDescription :: String
                       , listingTags :: [String]
                       , listingPermalink :: Maybe String
                       }

