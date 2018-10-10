{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}
module EventStore.Sqlite
  ( Handle
  , initHandle
  , aggregateIds
  , startAggregate
  , insertEvent
  , allEvents
  , foldEvents
  , foldAllEvents
  ) where


import           Control.Monad.IO.Class (MonadIO, liftIO)
import           Data.Aeson (FromJSON, ToJSON)
import qualified Data.Aeson as Aeson
import           Data.Maybe (mapMaybe)
import qualified Data.UUID as UUID
import qualified Data.UUID.V4 as UUID
import           Database.SQLite.Simple (Connection, Query)
import qualified Database.SQLite.Simple as Sql
import           EventStore.Event (Event(Event), AggregateId, Number)
import qualified EventStore.Event as Event


data Handle = Handle { connectionString :: String }

initHandle :: MonadIO m => String -> m Handle
initHandle conStr = undefined


aggregateIds :: MonadIO m => Handle -> m [AggregateId]
aggregateIds handle = undefined


startAggregate :: MonadIO m => ToJSON ev => Handle -> ev -> m AggregateId
startAggregate handle event = undefined


insertEvent :: MonadIO m => ToJSON ev => Handle -> AggregateId -> ev -> m Number
insertEvent handle aId event = undefined


allEvents :: MonadIO m => FromJSON ev => Handle -> m [Event ev]
allEvents handle = undefined


foldEvents :: MonadIO m => FromJSON ev => Handle -> AggregateId -> (s -> ev -> s) -> s -> m s
foldEvents handle aId fold s0 = undefined


foldAllEvents :: MonadIO m => FromJSON ev => Handle -> (s -> Event ev -> s) -> s -> m s
foldAllEvents handle fold s0 = undefined
