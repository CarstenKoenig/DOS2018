module EventStore.Event
  ( AggregateId
  , Number
  , Event (..)
  ) where

import Data.Int (Int64)
import Data.UUID (UUID)

type Number = Int64
type AggregateId = UUID

data Event a = Event
  { number    :: Number
  , aggregate :: AggregateId
  , value     :: a
  } deriving Show
