{-# LANGUAGE BangPatterns               #-}
{-# LANGUAGE DerivingStrategies         #-}
{-# LANGUAGE GeneralizedNewtypeDeriving #-}
{-# LANGUAGE ScopedTypeVariables        #-}

module Data.Record.Anon.Internal.Core.Util.StrictVector (
    StrictVector -- opaque
    -- * Reads
  , (!)
    -- * Conversion
  , fromList
  , fromListN
  , fromLazy
  , toLazy
    -- * Non-monadic combinators
  , (//)
  , update
  , backpermute
  , zipWith
    -- * Monadic combinators
  , mapM
  , zipWithM
  ) where

import Prelude hiding (mapM, zipWith)

import Control.Monad (forM_)
import Data.Primitive.SmallArray

import qualified Control.Monad as Monad
import qualified Data.Foldable as Foldable
import qualified Data.Vector   as Lazy

{-------------------------------------------------------------------------------
  Definition
-------------------------------------------------------------------------------}

-- | Strict vector
--
-- Implemented as a wrapper around a 'SmallArray'.
--
-- NOTE: None of the operations on 'Vector' do any bounds checking.
--
-- NOTE: 'Vector' is implemented as a newtype around 'SmallArray', which in turn
-- is defined as
--
-- > data SmallArray a = SmallArray (SmallArray# a)
--
-- Furthermore, 'Canonical' is a newtype around 'Vector', which is then used in
-- 'Record' as
--
-- > data Record (f :: k -> Type) (r :: Row k) = Record {
-- >       recordCanon :: {-# UNPACK #-} !(Canonical f)
-- >     , ..
-- >     }
--
-- This means that 'Record' will have /direct/ access (no pointers) to the
-- 'SmallArray#'.
newtype StrictVector a = WrapLazy { unwrapLazy :: SmallArray a }
  deriving newtype (Show, Eq, Foldable, Semigroup, Monoid)

{-------------------------------------------------------------------------------
  Reads
-------------------------------------------------------------------------------}

(!) :: StrictVector a -> Int -> a
(!) = indexSmallArray . unwrapLazy

{-------------------------------------------------------------------------------
  Conversion
-------------------------------------------------------------------------------}

fromList :: [a] -> StrictVector a
fromList as = fromListN (length as) as

fromListN :: Int -> [a] -> StrictVector a
fromListN n as = WrapLazy $
    createSmallArray n undefined $ \r ->
      forM_ (zip [0..] as) $ \(i, !a) ->
        writeSmallArray r i a

fromLazy :: Lazy.Vector a -> StrictVector a
fromLazy v =
    fromListN (Lazy.length v) (Lazy.toList v)

toLazy :: StrictVector a -> Lazy.Vector a
toLazy (WrapLazy arr) =
    Lazy.fromListN (sizeofSmallArray arr) (Foldable.toList arr)

{-------------------------------------------------------------------------------
  Non-monadic combinators
-------------------------------------------------------------------------------}

instance Functor StrictVector where
  fmap f (WrapLazy as) = WrapLazy $
      createSmallArray newSize undefined $ \r ->
        forArrayM_ as $ \i a -> writeSmallArray r i $! f a
    where
      newSize :: Int
      newSize = sizeofSmallArray as

(//) :: StrictVector a -> [(Int, a)] -> StrictVector a
(//) (WrapLazy as) as' = WrapLazy $ runSmallArray $ do
    r <- thawSmallArray as 0 newSize
    forM_ as' $ \(i, !a) -> writeSmallArray r i a
    return r
  where
    newSize :: Int
    newSize = sizeofSmallArray as

update :: StrictVector a -> StrictVector (Int, a) -> StrictVector a
update (WrapLazy as) (WrapLazy as') = WrapLazy $ runSmallArray $ do
    r <- thawSmallArray as 0 newSize
    forArrayM_ as' $ \_i (j, !a) -> writeSmallArray r j a
    return r
  where
    newSize :: Int
    newSize = sizeofSmallArray as

backpermute :: StrictVector a -> StrictVector Int -> StrictVector a
backpermute (WrapLazy as) (WrapLazy is) = WrapLazy $
    createSmallArray newSize undefined $ \r ->
      forArrayM_ is $ \i j -> writeSmallArray r i $! indexSmallArray as j
  where
    newSize :: Int
    newSize = length is

zipWith :: (a -> b -> c) -> StrictVector a -> StrictVector b -> StrictVector c
zipWith f (WrapLazy as) (WrapLazy bs) = WrapLazy $
    createSmallArray newSize undefined $ \r ->
      forM_ [0 .. newSize - 1] $ \i -> do
        let !c = f (indexSmallArray as i) (indexSmallArray bs i)
        writeSmallArray r i c
  where
    newSize :: Int
    newSize = min (sizeofSmallArray as) (sizeofSmallArray bs)

{-------------------------------------------------------------------------------
  Applicative combinators

  NOTE: The monadic combinators here do two traversals, first collecting all
  elements of the vector in memory, and then constructing the new vector. The
  alternative is to use 'traverseSmallArrayP', but it is only sound with
  certain monads. Since this restriction would leak out to users of the library
  (through the monadic combinators on 'Record'), we prefer to avoid it.
-------------------------------------------------------------------------------}

mapM :: forall m a b.
     Applicative m
  => (a -> m b) -> StrictVector a -> m (StrictVector b)
mapM f (WrapLazy as) =
    fromListN newSize <$>
      traverse f (Foldable.toList as)
  where
    newSize :: Int
    newSize = sizeofSmallArray as

zipWithM ::
     Applicative m
  => (a -> b -> m c) -> StrictVector a -> StrictVector b -> m (StrictVector c)
zipWithM f (WrapLazy as) (WrapLazy bs) = do
    fromListN newSize <$>
      Monad.zipWithM f (Foldable.toList as) (Foldable.toList bs)
  where
    newSize :: Int
    newSize = min (sizeofSmallArray as) (sizeofSmallArray bs)

{-------------------------------------------------------------------------------
  Internal auxiliary
-------------------------------------------------------------------------------}

forArrayM_ :: forall m a. Monad m => SmallArray a -> (Int -> a -> m ()) -> m ()
forArrayM_ arr f = go 0
  where
    go :: Int -> m ()
    go i
      | i < sizeofSmallArray arr
      = f i (indexSmallArray arr i) >> go (succ i)

      | otherwise
      = return ()
