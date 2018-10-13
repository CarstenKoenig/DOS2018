module WordWrap
  ( wrap
  ) where

import Prelude hiding (Word)
import Data.List (intercalate)

type Word = String
type Line = [Word]

wrap :: Int -> String -> String
wrap lineLen =
  intercalate "\n" . map unwords . collectLines lineLen . splitLongWords . words
  where
    splitLongWords = concatMap split
    split word
      | length word <= lineLen = [word]
      | otherwise = take lineLen word : split (drop lineLen word)


collectLines :: Int -> [Word] -> [Line]
collectLines _ [] = []
collectLines lineLen words =
  let (line, words') = takeWords lineLen words
  in line : collectLines lineLen words'


takeWords :: Int -> [Word] -> ([Word], [Word])
takeWords _ [] = ([], [])
takeWords remaining words@(word:words')
  | length word > remaining = ([], words)
  | otherwise =
    let (taken,rest) = takeWords (remaining - length word - 1) words'
    in (word : taken, rest)
