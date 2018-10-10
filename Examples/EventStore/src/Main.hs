{-# LANGUAGE DeriveGeneric #-}
{-# LANGUAGE LambdaCase #-}
module Main where

import Cli
import Konto

main :: IO ()
main = do
  konto <- Konto.initialisieren "konto.sqlite"
  runCli konto
