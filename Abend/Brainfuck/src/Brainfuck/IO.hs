module Brainfuck.IO
  ( output
  , input
  ) where

import Control.Monad.IO.Class (MonadIO, liftIO)
import Data.Word (Word8)


output :: MonadIO m => Word8 -> m ()
output = liftIO <$> putChar . toChar


input :: MonadIO m => m Word8
input = fromChar <$> liftIO getChar


toChar :: Integral n => n -> Char
toChar = toEnum . fromIntegral


fromChar :: Integral n => Char -> n
fromChar = fromIntegral . fromEnum
