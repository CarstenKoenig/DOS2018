{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE DeriveFunctor #-}
{-# LANGUAGE StandaloneDeriving #-}


module EventStore.Projections
  ( Projection
  , create
  , use
  , latest
  , EventStore.Projections.sum
  , EventStore.Projections.product
  , foldM
  ) where

import Data.Aeson (FromJSON)
import Data.Monoid (Monoid, (<>), Last(..), Sum(..), Product(..))
import EventStore.Event (Event)


data Projection ev res =
  forall s . MkProj s (s -> ev -> s) (s -> res)

deriving instance Functor (Projection ev)

instance Applicative (Projection ev) where
  pure a = create () const (const a)
  pf <*> px = (\(f,x) -> f x) <$> zipP pf px


create :: s -> (s -> ev -> s) -> (s -> res) -> Projection ev res
create = MkProj


use :: Monad m => (forall s . (s -> ev -> s) -> s -> m s) -> Projection ev res -> m res
use folder (MkProj s0 ff fm) = fm <$> folder ff s0


----------------------------------------------------------------------
-- basic projections

latest :: (ev -> Maybe a) -> Projection ev (Maybe a)
latest choose =
  getLast <$> foldM (Last . choose)


sum :: Num n => (ev -> n) -> Projection ev n
sum getN =
  getSum <$> foldM (Sum . getN)


product :: Num n => (ev -> n) -> Projection ev n
product getN =
  getProduct <$> foldM (Product . getN)


foldM :: Monoid m => (ev -> m) -> Projection ev m
foldM getM =
  create mempty (\s ev -> s <> getM ev) id


----------------------------------------------------------------------
-- helpers

zipP :: Projection ev a -> Projection ev b -> Projection ev (a,b)
zipP (MkProj ia fa ma) (MkProj ib fb mb) =
  create (ia,ib) (\(sa,sb) ev -> (fa sa ev, fb sb ev)) (\(sa,sb) -> (ma sa, mb sb))
