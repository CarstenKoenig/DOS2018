{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE FlexibleContexts #-}
module Brainfuck.ZipperTape
    ( Tape
    , TapeM
    , empty
    , currentValue
    , setValue
    , increase
    , decrease
    , moveRight
    , moveLeft
    )where


import           Control.Monad.State
import           Data.Maybe (fromMaybe)
import           Zipper (Zipper)
import qualified Zipper as Z


type Tape a = Zipper a


type TapeM n m = (Num n, MonadState (Tape n) m)


empty :: Num a => Tape a
empty = Z.empty 0


currentValue :: TapeM n m => m n
currentValue = gets (fromMaybe 0 . Z.value)


setValue :: TapeM n m => n -> m ()
setValue n = modify (Z.setValue n)


increase :: TapeM n m => m ()
increase = modify (Z.modify (+ 1))


decrease :: TapeM n m => m ()
decrease = modify (Z.modify (subtract 1))


moveLeft :: TapeM n m => m ()
moveLeft = modify Z.left


moveRight :: TapeM n m => m ()
moveRight = modify Z.right
