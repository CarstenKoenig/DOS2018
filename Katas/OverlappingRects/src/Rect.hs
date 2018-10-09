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


data Rect a = Rect (Interval a) (Interval a)
  deriving Eq


type Coord a = (a,a)


rect :: Ord a => Coord a -> Coord a -> Rect a
rect (blx,bly) (trx,try) = Rect (I.interval blx trx) (I.interval bly try)


area :: Num a => Rect a -> a
area (Rect ix iy) = I.length ix * I.length iy


intersect :: Ord a => Rect a -> Rect a -> Rect a
intersect (Rect ix iy) (Rect ix' iy') = Rect (I.intersect ix ix') (I.intersect iy iy')
