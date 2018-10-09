module CoinChange
  ( wechsle
  , Betrag
  , Muenze
  ) where


type Muenze = Int
type Betrag = Integer


wechsle :: Betrag -> [Muenze]
wechsle = wechsleGreedy euros


wechsleGreedy :: [Muenze] -> Betrag -> [Muenze]
wechsleGreedy _ 0 = []
wechsleGreedy muenzen@(muenze:restMuenzen) rest
  | fromIntegral muenze > rest = wechsleGreedy restMuenzen rest
  | otherwise                  = muenze : wechsleGreedy muenzen (rest - fromIntegral muenze)


euros :: [Muenze]
euros = [ 200, 100, 50, 20, 10, 5, 2, 1 ]
