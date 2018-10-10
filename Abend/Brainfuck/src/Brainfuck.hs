module Brainfuck
  ( brainfuck
  , interpretInstructions
  , parseBf
  , parseFile
  , Instruction (..)
  ) where

import Brainfuck.Ast
import Brainfuck.IO
import Brainfuck.Parser
import Brainfuck.MapTape
import Data.Word (Word8)
import Control.Monad.State

type BrainfuckM = StateT (Tape Word8) IO


brainfuck :: FilePath -> IO ()
brainfuck file = undefined


interpretInstructions :: [Instruction] -> BrainfuckM ()
interpretInstructions = undefined


parseFile :: FilePath -> IO [Instruction]
parseFile file = undefined

