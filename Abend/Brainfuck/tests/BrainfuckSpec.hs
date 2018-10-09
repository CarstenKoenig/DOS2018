module BrainfuckSpec where

import Test.Hspec

import Brainfuck

main :: IO ()
main = hspec spec


spec :: Spec
spec = do
  describe "parsing single commands" $ do
    it "'>' is parsed as TapeRight" $
      parseCommand ">" `shouldBe` Right TapeRight
    it "'<' is parsed as TapeLeft" $
      parseCommand "<" `shouldBe` Right TapeLeft
    it "'+' is parsed as Increment" $
      parseCommand "+" `shouldBe` Right Increment
    it "'-' is parsed as Decrement" $
      parseCommand "-" `shouldBe` Right Decrement
    it "'.' is parsed as PutChar" $
      parseCommand "." `shouldBe` Right PutChar
    it "',' is parsed as GetChar" $
      parseCommand "," `shouldBe` Right GetChar
    it "'[-]' is parsed as Loop [Decrement]" $
      parseCommand "[-]" `shouldBe` Right (Loop [Decrement])
  describe "parsing instructions" $
    it "'>+<' is parsed as [TapeRight, Increment, TapeLeft]" $
      parseInstructions ">[-]<" `shouldBe` Right [TapeRight, Loop [ Decrement ], TapeLeft]


parseCommand :: String -> Either String Instruction
parseCommand = safeHead . parseBf
  where safeHead (Left err)    = Left err
        safeHead (Right [])    = Left "did not parse any instructions"
        safeHead (Right (h:_)) = Right h

parseInstructions :: String -> Either String [Instruction]
parseInstructions = parseBf

