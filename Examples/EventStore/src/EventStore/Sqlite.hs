{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}
module EventStore.Sqlite
  ( Handle
  , initHandle
  , insertEvent
  , allEvents
  , aggregateEvents
  , foldEvents
  , foldAllEvents
  ) where


import           Control.Monad.IO.Class (MonadIO, liftIO)
import           Data.Aeson (FromJSON, ToJSON)
import qualified Data.Aeson as Aeson
import qualified Data.UUID as UUID
import           Database.SQLite.Simple (Connection, Query, (:.)(..))
import qualified Database.SQLite.Simple as Sql
import           EventStore.Event (Event(Event), AggregateId, EventNumber)
import qualified EventStore.Event as Event


data Handle = Handle { connectionString :: String }

initHandle :: MonadIO m => String -> m Handle
initHandle conStr = do
  let handle = Handle conStr
  initializeDb handle
  return handle
  where
    initializeDb handle = withHandle handle $ \conn ->
      Sql.execute_ conn "CREATE TABLE IF NOT EXISTS events (id INTEGER PRIMARY KEY, aggregateId TEXT, json TEXT)"


insertEvent :: MonadIO m => ToJSON ev => Handle -> AggregateId -> ev -> m EventNumber
insertEvent handle aId event = withHandle handle $ \ conn -> do
  Sql.execute conn "INSERT INTO events (aggregateId, json) VALUES (?,?)" (Event aId event)
  Sql.lastInsertRowId conn


allEvents :: MonadIO m => FromJSON ev => Handle -> m [(EventNumber, Event ev)]
allEvents handle = withHandle handle $ \ conn -> do
  res <- Sql.query_ conn "SELECT * FROM events"
  return $ (\ (nr :. ev) -> (Sql.fromOnly nr, ev)) <$> res


aggregateEvents :: MonadIO m => FromJSON ev => Handle  -> AggregateId -> m [(EventNumber, ev)]
aggregateEvents handle aId = withHandle handle $ \ conn -> do
  res <- Sql.query conn "SELECT * FROM events WHERE aggregateId = ?" (Sql.Only (UUID.toString aId))
  return $ (\ (nr :. Event _ ev) -> (Sql.fromOnly nr, ev)) <$> res


foldEvents :: MonadIO m => FromJSON ev => Handle -> AggregateId -> s -> (s -> EventNumber -> ev -> s) -> m s
foldEvents handle aId s0 fold = withHandle handle $ \ conn ->
  Sql.fold conn "SELECT * FROM events WHERE aggregateId = ?" (Sql.Only (UUID.toString aId)) s0 foldQuery
  where foldQuery s (nr :. Event _ ev) = return $ fold s (Sql.fromOnly nr) ev


foldAllEvents :: MonadIO m => FromJSON ev => Handle -> s -> (s -> EventNumber -> Event ev -> s) -> m s
foldAllEvents handle s0 fold = withHandle handle $ \ conn ->
  Sql.fold_ conn "SELECT * FROM events" s0 foldQuery
  where foldQuery s (nr :. ev) = return $ fold s (Sql.fromOnly nr) ev


withHandle :: MonadIO m => Handle -> (Connection ->  IO a) -> m a
withHandle (Handle conStr) action = liftIO $ Sql.withConnection conStr action


instance FromJSON a => Sql.FromRow (Event a) where
  fromRow = Event <$> uuidField <*> jsonField
    where
      uuidField = Sql.field >>= maybe (fail "could not parse UUID") return . UUID.fromString
      jsonField = Sql.field >>= maybe (fail "cound not decode JSON") return . Aeson.decode


instance ToJSON a => Sql.ToRow (Event a) where
  toRow (Event aId value) = Sql.toRow (UUID.toString aId, Aeson.encode value)
