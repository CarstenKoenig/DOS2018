module RectSpec where

import Test.Hspec
import Test.QuickCheck

import Rect

main :: IO ()
main = hspec spec


spec :: Spec
spec = do
  describe "area of an rectangle" $ do
    it "is correct on a simple case" $
      area (rect (0,0) (5,5)) `shouldBe` 25
  describe "overlapping area" $ do
    -- as the algorithm is based on interval-length
    -- this is really (more than) enough - feel free to add more though
    it "is 0 for non overlapping rectangles" $
      let r1 = rect (0,0) (1,1)
          r2 = rect (2,2) (3,3)
      in area (r1 `intersect` r2) `shouldBe` 0
    it "is the area of the inner for nested rectangles" $
      let r1 = rect (0,0) (10,10)
          r2 = rect (2,2) (4,5)
      in area (r1 `intersect` r2) `shouldBe` 6
    it "is the area of the common rectangle for overlapping rectangles" $
      let r1 = rect (0,0) (5,5)
          r2 = rect (2,2) (7,8)
      in area (r1 `intersect` r2) `shouldBe` 9
    it "is 0 for touching rectangles"$
      let r1 = rect (0,0) (5,5)
          r2 = rect (5,2) (7,8)
      in area (r1 `intersect` r2) `shouldBe` 0
