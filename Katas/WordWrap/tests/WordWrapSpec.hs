module WordWrapSpec where

import Test.Hspec
import Test.QuickCheck

import WordWrap

main :: IO ()
main = hspec spec


spec :: Spec
spec = do
  describe "wrap" $ do
    it "is returning the input if it fits the line" $
      wrap 6 "hello" `shouldBe` "hello"
    it "splits after words if the input does not fit the line" $
      wrap 6 "hello world!" `shouldBe` "hello\nworld!"
    it "correctly counts spaces" $
      wrap 10 "a lot of words for a single line" `shouldBe` "a lot of\nwords for\na single\nline"
    it "fits more words in a single line if it can" $
      wrap 14 "this is sparta" `shouldBe` "this is sparta"
    it "does not split words if it does not need to" $
      wrap 9 "this is sparta" `shouldBe` "this is\nsparta"
    it "does split words if they are longer than a line" $
      wrap 5 "notsparta" `shouldBe` "notsp\narta"
