{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE LambdaCase #-}
module Main where

import           Data.Aeson (FromJSON, ToJSON)
import qualified EventStore as Store
import qualified EventStore.Projections as Projections
import           GHC.Generics

main :: IO ()
main = do
  konto <- kontoInitialisieren "konto.sqlite"
  putStr "aktueller Kontostand:"
  kontoStand konto >>= print

  putStrLn "Einzahlen - Betrag?"
  betrag <- readLn
  putStrLn "Grund?"
  grund <- getLine
  einzahlen konto grund betrag

  putStr "\n\nneuer Kontostand:"
  kontoStand konto >>= print


data Konto
  = Konto Store.Handle Store.AggregateId


kontoInitialisieren :: FilePath -> IO Konto
kontoInitialisieren dbFile = do
  handle <- Store.initHandle dbFile
  agIds <- Store.aggregateIds handle
  case agIds of
    (kontoId:_) -> return $ Konto handle kontoId
    [] -> do
      kontoId <- Store.startAggregate handle (Einzahlung "Konto eröffnet" 0)
      return $ Konto handle kontoId


einzahlen :: Konto -> String -> Int -> IO Int
einzahlen konto@(Konto handle kontoId) text betrag = do
  Store.insertEvent handle kontoId (Einzahlung text betrag)
  kontoStand konto


abheben :: Konto -> String -> Int -> IO Int
abheben konto@(Konto handle kontoId) text betrag = do
  Store.insertEvent handle kontoId (Auszahlung text betrag)
  kontoStand konto


kontoStand :: Konto -> IO Int
kontoStand (Konto handle kontoId) = Store.load handle kontostandP kontoId


data Buchung
  = Einzahlung String Int
  | Auszahlung String Int
  deriving (Generic, Show)


instance FromJSON Buchung
instance ToJSON Buchung


kontostandP :: Store.Projection Buchung Int
kontostandP = Projections.sum (\case
                                  (Einzahlung _ p) -> p
                                  (Auszahlung _ n) -> negate n)
