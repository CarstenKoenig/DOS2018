module Brainfuck.IO
  ( output
  , input
  ) where

import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Word (Word8)


output :: MonadIO m => Word8 -> m ()
output = undefined


input :: MonadIO m => m Word8
input = undefined


toChar :: Integral n => n -> Char
toChar = undefined


fromChar :: Integral n => Char -> n
fromChar = undefined
