{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE FlexibleContexts #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE TypeOperators #-}

module Cli
  (runCli
  ) where

import           Control.Monad (forM_)
import           Data.Decimal (Decimal)
import           Data.Semigroup ((<>))
import qualified Konto
import           Konto (Konto)
import           Options.Applicative
import           Text.Read (readMaybe)


runCli :: Konto -> IO ()
runCli konto = do
  cmd  <- execParser opts

  case cmd of
    ZeigeKontostand            -> zeigeKontostand konto
    Einzahlen bemerkung betrag -> einzahlen konto bemerkung betrag
    Abheben   bemerkung betrag -> abheben konto bemerkung betrag

  where
    opts      = info (cmdParser <**> helper) (fullDesc <> header "Mein kleines Konto")
    cmdParser = subparser
      (  command "stand"     (info (pure ZeigeKontostand) ( progDesc "zeigt den aktuellen Kontostand"))
      <> command "einzahlen" (info einOpts                ( progDesc "Betrag einzahlen"))
      <> command "abheben"   (info ausOpts                ( progDesc "Betrag abheben"))
      )
    einOpts   = configEinzahlen <**> helper
    ausOpts   = configAuszahlen <**> helper


zeigeKontostand :: Konto -> IO ()
zeigeKontostand konto = do
  stand <- Konto.stand konto
  putStrLn $ "ihr aktueller Kontostand ist " ++ show stand ++ "€"


einzahlen :: Konto -> String -> Decimal -> IO ()
einzahlen konto text betrag = do
  stand <- Konto.einzahlen konto text betrag
  putStrLn $ "Sie haben " ++ show betrag ++ "€ eingezahlt - ihr aktueller Kontostand ist " ++ show stand ++ "€"


abheben :: Konto -> String -> Decimal -> IO ()
abheben konto text betrag = do
  stand <- Konto.abheben konto text betrag
  putStrLn $ "Sie haben " ++ show betrag ++ "€ abgehoben - ihr aktueller Kontostand ist " ++ show stand ++ "€"


data Kommando
  = ZeigeKontostand
  | Einzahlen String Decimal
  | Abheben String Decimal


configEinzahlen :: Parser Kommando
configEinzahlen = Einzahlen <$> textOption <*> betragArgument
  where
    textOption = option str
      ( long "text"
      <> short 't'
      <> metavar "TEXT"
      <> showDefault
      <> value "Einzahlung"
      <> help "die Bemerkung zur Einzahlung")
    betragArgument = argument positivDecimal
      ( metavar "BETRAG"
      <> help "der einzuzahlende Betrag")


configAuszahlen :: Parser Kommando
configAuszahlen = Abheben <$> textOption <*> betragArgument
  where
    textOption = option str
      ( long "text"
      <> short 't'
      <> metavar "TEXT"
      <> showDefault
      <> value "Abhebung"
      <> help "die Bemerkung zur Abhebung")
    betragArgument = argument positivDecimal
      ( metavar "BETRAG"
      <> help "der einzuzahlende Betrag")


positivDecimal :: ReadM Decimal
positivDecimal = do
  betrag <- auto
  if betrag <= 0 then readerError "Betrag muss positiv sein"
  else return betrag
