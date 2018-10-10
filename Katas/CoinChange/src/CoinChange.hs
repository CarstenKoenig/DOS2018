module CoinChange
  ( wechsle
  , Betrag
  , Muenze
  ) where


type Muenze = Int
type Betrag = Integer


wechsle :: Betrag -> [Muenze]
wechsle = undefined

euros :: [Muenze]
euros = [ 200, 100, 50, 20, 10, 5, 2, 1 ]
