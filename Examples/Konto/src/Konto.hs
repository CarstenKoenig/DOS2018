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
import           GHC.Generics


data Konto
  = Konto


initialisieren :: FilePath -> IO Konto
initialisieren dbFile = undefined


einzahlen :: Konto -> String -> Decimal -> IO Decimal
einzahlen = undefined


abheben :: Konto -> String -> Decimal -> IO Decimal
abheben = undefined


stand :: Konto -> IO Decimal
stand = undefined


-- brauchen leider ein paar Orphans
deriving instance Generic (DecimalRaw Integer)
instance FromJSON Decimal
instance ToJSON Decimal
