module Interval
  ( Interval
  , interval
  , Interval.length
  , intersect
  , empty
  ) where


data Interval a
  = Interval a a
  | Empty
  deriving (Eq, Show)


interval :: Ord a => a -> a -> Interval a
interval a b
  | a <= b = Interval a b
  | otherwise = empty


empty :: Interval a
empty = Empty


length :: Num a => Interval a -> a
length (Interval a b) = b - a
length Empty = 0


intersect :: Ord a => Interval a -> Interval a -> Interval a
intersect Empty _                         = Empty
intersect _ Empty                         = Empty
intersect (Interval a b) (Interval a' b') = interval (max a a') (min b b')
