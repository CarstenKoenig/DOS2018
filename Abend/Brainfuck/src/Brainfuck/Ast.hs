module Brainfuck.Ast where


data Instruction
  = TapeRight
  | TapeLeft
  | Increment
  | Decrement
  | GetChar
  | PutChar
  | Loop [Instruction]
  deriving (Show, Eq)
