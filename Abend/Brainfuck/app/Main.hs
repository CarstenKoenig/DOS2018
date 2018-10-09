module Main where

import Brainfuck
import System.Environment

main :: IO ()
main = do
  file:_ <- getArgs
  brainfuck file
