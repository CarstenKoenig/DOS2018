module Brainfuck.Parser
  ( parseBf
  ) where

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
    removeNonTokens = undefined

type Parser = Parsec String ()


instructionsParser :: Parser [Instruction]
instructionsParser = undefined
