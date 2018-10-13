module Brainfuck.Parser where

import           Brainfuck.Ast
import           Control.Applicative ((*>),(<*))
import           Data.Bifunctor (first)
import           Text.Parsec (Parsec)
import qualified Text.Parsec as P
import qualified Text.Parsec.Char as PC


parseBf :: String -> Either String [Instruction]
parseBf =
  first show . P.runParser instructionsParser () "Brainfuck-Parser" . removeNonTokens
  where
    removeNonTokens = filter (`elem` ['>','<','+','-',',','.','[',']'])

type Parser = Parsec String ()


instructionsParser :: Parser [Instruction]
instructionsParser = P.many instructionParser


instructionParser :: Parser Instruction
instructionParser = P.choice [ tapeRight
                             , tapeLeft
                             , increment
                             , decrement
                             , readChar
                             , writeChar
                             , loop]
  where tapeRight=
          PC.char '>' *> return TapeRight
        tapeLeft =
          PC.char '<' *> return TapeLeft
        increment =
          PC.char '+' *> return Increment
        decrement =
          PC.char '-' *> return Decrement
        readChar =
          PC.char ',' *> return GetChar
        writeChar =
          PC.char '.' *> return PutChar
        loop = fmap Loop $
          PC.char '[' *> instructionsParser <* PC.char ']'
