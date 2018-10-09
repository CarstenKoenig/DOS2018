module Brainfuck.ZipperTapeSpec where

import Test.Hspec
import Control.Monad.State (State, evalState)

import Brainfuck.ZipperTape


main :: IO ()
main = hspec spec


spec :: Spec
spec = do
  describe "initial tape" $ do
    it "has value `0`" $
      runTape currentValue `shouldBe` 0
    context "changing the value" $ do
      it "increasing changes the currentValue to 1" $
        runTape (increase >> currentValue) `shouldBe` 1
      it "increasing twice changes the currentValue to 2" $
        runTape (increase >> increase >> currentValue) `shouldBe` 2
      it "decreasing changes the currentValue to -1" $
        runTape (decrease >> currentValue) `shouldBe` (-1)
      it "increasing and the decresing keeps the currentValue at 0" $
        runTape (increase >> decrease >> currentValue) `shouldBe` 0
    context "changing values and moving the tape" $ do
      it "move-right after increasing will have currentValue 0" $
        runTape (increase >> moveRight >> currentValue) `shouldBe` 0
      it "increase, move-right, decrease, move-left will have currentValue 1" $
        runTape (increase >> moveRight >> decrease >> moveLeft >> currentValue) `shouldBe` 1
      it "setValue will set the current Value" $
        runTape (setValue 42 >> currentValue) `shouldBe` 42


runTape :: State (Tape Int) a -> a
runTape comp =
  evalState comp empty
