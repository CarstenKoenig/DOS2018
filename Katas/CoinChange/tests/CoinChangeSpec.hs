module CoinChangeSpec where

import Test.Hspec
import Test.QuickCheck

import CoinChange

main :: IO ()
main = hspec spec


spec :: Spec
spec = do
  describe "wechsle" $ do
    it "für 173 ist [100,50,20,2,1]" $
      wechsle 173 `shouldBe` [100,50,20,2,1]
    it "zurückgegebene Münzen summieren sich auf den Betrag" $ property $
      \(NonNegative betrag) -> sum (wechsle $ betrag) == fromInteger betrag

