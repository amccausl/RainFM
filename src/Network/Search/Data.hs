
module Network.Search.Data
       ( SearchParameter
       ) where

data SearchParameter = SortParameter field asc
                     | GroupField field :: GroupField String
                     | PagingFilter perPage pageNum :: PagingFilter Int Int
                     | FacetFilter facet
                     | FieldSearch field query
                     | Keyword query
