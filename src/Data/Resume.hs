
module Data.Resume
       ( Resume(..)
       ) where

import Text.ICalendar.Parser
import Text.VCard.Types

data Resume = Resume { resumeSummary :: Maybe String
                     , resumeContact :: VCard
                     , resumeExperience :: [ICalendar]
                     , resumeEducation :: [ICalendar]
                     , resumeSkills :: [String]
                     , resumeAffiliations :: [VCard]
                     , resumePublications :: [String]
                     }
