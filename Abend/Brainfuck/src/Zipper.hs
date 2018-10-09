{-# LANGUAGE BangPatterns #-}
{-# LANGUAGE DeriveFunctor #-}
module Zipper
  ( Zipper
  , empty
  , value
  , setValue
  , modify
  , right
  , left
  ) where


data Zipper a
  = Zipper [a] [a]
  deriving (Show, Eq, Functor)


empty :: a -> Zipper a
empty a = Zipper (repeat a) (repeat a)


value :: Zipper a -> Maybe a
value (Zipper _ (v:_)) = Just v


setValue :: a -> Zipper a -> Zipper a
setValue !v = modify (const v)


modify :: (a -> a) -> Zipper a -> Zipper a
modify f (Zipper ls (!v:rs)) = Zipper ls ((f $! v):rs)


right :: Zipper a -> Zipper a
right (Zipper ls (r:rs)) = Zipper (r:ls) rs


left :: Zipper a -> Zipper a
left (Zipper (l:ls) rs) = Zipper ls (l:rs)
