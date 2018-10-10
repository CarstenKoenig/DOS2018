module Rect
  ( Rect
  , Coord
  , rect
  , area
  , intersect
  ) where

import           Data.Char (toUpper)

import           Interval (Interval)
import qualified Interval as I


data Rect a = Rect ()
  deriving Eq

type Coord a = (a,a)


rect :: Ord a => Coord a -> Coord a -> Rect a
rect = undefined


area :: Num a => Rect a -> a
area = undefined


intersect :: Ord a => Rect a -> Rect a -> Rect a
intersect = undefined
