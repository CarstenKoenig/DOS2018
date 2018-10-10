{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE FlexibleContexts #-}

module Brainfuck.MapTape
    ( Tape
    , TapeM
    , empty
    , currentValue
    , setValue
    , increase
    , decrease
    , moveRight
    , moveLeft
    ) where


import           Control.Monad.State
import           Data.IntMap.Strict (IntMap)
import qualified Data.IntMap.Strict as M
import           Data.Maybe (fromMaybe)


data Tape a = Tape


type TapeM n m = (Num n, MonadState (Tape n) m)


empty :: Tape a
empty = undefined


currentValue :: TapeM n m => m n
currentValue = undefined


setValue :: TapeM n m => n -> m ()
setValue n = undefined


increase :: TapeM n m => m ()
increase = undefined


decrease :: TapeM n m => m ()
decrease = undefined


moveLeft :: TapeM n m => m ()
moveLeft = undefined


moveRight :: TapeM n m => m ()
moveRight = undefined
