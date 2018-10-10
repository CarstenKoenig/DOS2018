module EventStore
  ( Handle
  , module EventStore.Event
  , Sql.initHandle
  , Sql.aggregateIds
  , Sql.startAggregate
  , Sql.insertEvent
  , Sql.foldEvents
  ) where

import           Control.Monad.IO.Class (MonadIO)
import           Data.Aeson (FromJSON)
import           EventStore.Event
import           EventStore.Sqlite (Handle)
import qualified EventStore.Sqlite as Sql
