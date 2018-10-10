module Interval
  ( Interval
  , interval
  , Interval.length
  , intersect
  , empty
  ) where


data Interval a = Interval
  deriving (Show, Eq)


interval :: Ord a => a -> a -> Interval a
interval = undefined


empty :: Interval a
empty = undefined


length :: Num a => Interval a -> a
length = undefined


intersect :: Ord a => Interval a -> Interval a -> Interval a
intersect = undefined
