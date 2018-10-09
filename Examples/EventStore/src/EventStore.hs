module EventStore
  ( Handle
  , Sql.initHandle
  , Sql.aggregateIds
  , Sql.startAggregate
  , Sql.insertEvent
  , Projection
  , load
  ) where

import           Control.Monad.IO.Class (MonadIO)
import           Data.Aeson (FromJSON)
import           EventStore.Event
import           EventStore.Projections (Projection)
import qualified EventStore.Projections as Projections
import           EventStore.Sqlite (Handle)
import qualified EventStore.Sqlite as Sql


load :: MonadIO m => FromJSON ev => Handle -> Projection ev res -> AggregateId -> m res
load handle proj aId = Projections.use (Sql.foldEvents handle aId) proj
