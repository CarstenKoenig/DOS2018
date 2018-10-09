{-# LANGUAGE ScopedTypeVariables #-}
module IntervalSpec where

import Test.Hspec
import Test.QuickCheck

import Interval

main :: IO ()
main = hspec spec


spec :: Spec
spec = do
  describe "interval intersection" $ do
    it "intersection of an interval with itself is the interval" $ property $
      \ (a,b :: Int) -> let int = interval (min a b) (max a b) in int `intersect` int == int
    it "intersection of an itnerval with the empty interval is empty" $ property $
      \ (a,b :: Int) -> let int = interval (min a b) (max a b) in int `intersect` empty == empty
    it "interval inside another intersects to the smaller" $
      let int = interval 0 10
          int' = interval 2 8
      in (int `intersect` int') `shouldBe` int'
    it "interval inside another intersects to the smaller (flipped)" $
      let int = interval 0 10
          int' = interval 2 8
      in (int' `intersect` int) `shouldBe` int'
    it "for two intersecting intervals the intersection is the common part" $
      let int = interval 0 5
          int' = interval 2 7
      in (int `intersect` int') `shouldBe` interval 2 5
    it "for two intersecting intervals the intersection is the common part (flipped)" $
      let int = interval 0 5
          int' = interval 2 7
      in (int' `intersect` int) `shouldBe` interval 2 5
    it "non intersecting intervals have empty intersection" $
      let int = interval 0 4
          int' = interval 5 10
      in (int `intersect` int') `shouldBe` empty
    it "non intersecting intervals have empty intersection (flipped)" $
      let int = interval 0 4
          int' = interval 5 10
      in (int' `intersect` int) `shouldBe` empty

