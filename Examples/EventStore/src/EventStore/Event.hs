{-# LANGUAGE DeriveGeneric #-}
module EventStore.Event
  ( AggregateId
  , EventNumber
  , Event (..)
  ) where

import Data.Aeson (ToJSON, FromJSON)
import Data.Int (Int64)
import GHC.Generics
import Data.UUID (UUID)

type EventNumber = Int64
type AggregateId = UUID

data Event a = Event
  { aggregate :: AggregateId
  , value     :: a
  } deriving (Generic, Show)

instance FromJSON a => FromJSON (Event a)
instance ToJSON a => ToJSON (Event a)
