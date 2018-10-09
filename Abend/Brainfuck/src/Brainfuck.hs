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
brainfuck file = do
  insts <- parseFile file
  evalStateT (interpretInstructions insts) empty


interpretInstructions :: [Instruction] -> BrainfuckM ()
interpretInstructions = mapM_ interpretInstruction


interpretInstruction :: Instruction -> BrainfuckM ()
interpretInstruction TapeRight  = moveRight
interpretInstruction TapeLeft   = moveLeft
interpretInstruction Increment  = increase
interpretInstruction Decrement  = decrease
interpretInstruction GetChar    = input >>= setValue
interpretInstruction PutChar    = currentValue >>= output
interpretInstruction (Loop ins) = loop
  where loop = do
          val <- currentValue
          if val /= 0
            then interpretInstructions ins >> loop
            else return ()


parseFile :: FilePath -> IO [Instruction]
parseFile file = do
  content <- readFile file
  case parseBf content of
    Left  err   -> fail err
    Right insts -> return insts

