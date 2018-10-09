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


data Tape a = Tape !Int (IntMap a)


type TapeM n m = (Num n, MonadState (Tape n) m)


empty :: Tape a
empty = Tape 0 M.empty


currentValue :: TapeM n m => m n
currentValue = gets value
  where value (Tape ind m) = fromMaybe 0 $ M.lookup ind m


setValue :: TapeM n m => n -> m ()
setValue n = modify set
  where set (Tape ind m) = Tape ind $ M.insert ind n m


increase :: TapeM n m => m ()
increase = modify incr
  where incr (Tape ind m) = Tape ind $ M.insertWith (+) ind 1 m


decrease :: TapeM n m => m ()
decrease = modify decr
  where decr (Tape ind m) = Tape ind $ M.insertWith (+) ind (-1) m


moveLeft :: TapeM n m => m ()
moveLeft = modify left
  where left (Tape ind m) = Tape (ind+1) m


moveRight :: TapeM n m => m ()
moveRight = modify right
  where right (Tape ind m) = Tape (ind-1) m
