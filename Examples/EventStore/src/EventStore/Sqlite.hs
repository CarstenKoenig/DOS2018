{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE OverloadedStrings #-}
module EventStore.Sqlite
  ( Handle
  , initHandle
  , insertEvent
  , allEvents
  , foldEvents
  , foldAllEvents
  ) where


import           Control.Monad.IO.Class (MonadIO, liftIO)
import           Data.Aeson (FromJSON, ToJSON)
import qualified Data.Aeson as Aeson
import qualified Data.UUID as UUID
import           Database.SQLite.Simple (Connection, Query, (:.)(..))
import qualified Database.SQLite.Simple as Sql
import           EventStore.Event (Event(Event), AggregateId, Number)
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


insertEvent :: MonadIO m => ToJSON ev => Handle -> AggregateId -> ev -> m Number
insertEvent handle aId event = withHandle handle $ \ conn -> do
  Sql.execute conn "INSERT INTO events (aggregateId, json) VALUES (?,?)" (UUID.toString aId, Aeson.encode event)
  Sql.lastInsertRowId conn


allEvents :: MonadIO m => FromJSON ev => Handle -> m [Event ev]
allEvents handle = reverse <$> foldAllEvents handle (flip (:)) []


foldEvents :: MonadIO m => FromJSON ev => Handle -> AggregateId -> (s -> Number -> ev -> s) -> s -> m s
foldEvents handle aId fold s0 = withHandle handle $ \ conn ->
  Sql.fold conn "SELECT * FROM events WHERE aggregateId = ?" (Sql.Only (UUID.toString aId)) s0 foldQuery
  where foldQuery s (Event nr _ ev) = return $ fold s nr ev


foldAllEvents :: MonadIO m => FromJSON ev => Handle -> (s -> Event ev -> s) -> s -> m s
foldAllEvents handle fold s0 = withHandle handle $ \ conn ->
  Sql.fold_ conn "SELECT * FROM events" s0 foldQuery
  where foldQuery s ev = return $ fold s ev


withHandle :: MonadIO m => Handle -> (Connection ->  IO a) -> m a
withHandle (Handle conStr) action = liftIO $ Sql.withConnection conStr action


instance FromJSON a => Sql.FromRow (Event a) where
  fromRow = Event <$> Sql.field <*> uuidField <*> jsonField
    where
      uuidField = Sql.field >>= maybe (fail "could not parse UUID") return . UUID.fromString
      jsonField = Sql.field >>= maybe (fail "cound not decode JSON") return . Aeson.decode
