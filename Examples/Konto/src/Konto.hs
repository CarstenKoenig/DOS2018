{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE TypeSynonymInstances #-}
{-# LANGUAGE StandaloneDeriving #-}
{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE LambdaCase #-}

module Konto
  ( Konto
  , initialisieren
  , einzahlen
  , abheben
  , stand
  ) where


import           Data.Aeson (FromJSON, ToJSON)
import           Data.Decimal (Decimal, DecimalRaw(..))
import qualified EventStore as Store
import qualified EventStore.Projections as Projections
import           GHC.Generics


data Konto
  = Konto Store.Handle Store.AggregateId


initialisieren :: FilePath -> IO Konto
initialisieren dbFile = do
  handle <- Store.initHandle dbFile
  agIds <- Store.aggregateIds handle
  case agIds of
    (kontoId:_) -> return $ Konto handle kontoId
    [] -> do
      kontoId <- Store.startAggregate handle (Haben "Konto eröffnet" 0)
      return $ Konto handle kontoId


einzahlen :: Konto -> String -> Decimal -> IO Decimal
einzahlen konto@(Konto handle kontoId) text betrag = do
  Store.insertEvent handle kontoId (Haben text betrag)
  stand konto


abheben :: Konto -> String -> Decimal -> IO Decimal
abheben konto@(Konto handle kontoId) text betrag = do
  Store.insertEvent handle kontoId (Soll text betrag)
  stand konto


stand :: Konto -> IO Decimal
stand (Konto handle kontoId) =
  Store.load handle kontostandP kontoId


data Buchung
  = Haben String Decimal
  | Soll  String Decimal
  deriving (Generic, Show)


instance FromJSON Buchung
instance ToJSON Buchung


-- brauchen leider ein paar Orphans
deriving instance Generic (DecimalRaw Integer)
instance FromJSON Decimal
instance ToJSON Decimal


-- Projektionen
kontostandP :: Store.Projection Buchung Decimal
kontostandP = Projections.sum
              (\case
                  (Haben _ p) -> p
                  (Soll  _ n) -> negate n)
