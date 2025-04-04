{-# LANGUAGE ConstraintKinds           #-}
{-# LANGUAGE DataKinds                 #-}
{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE FlexibleContexts          #-}
{-# LANGUAGE FlexibleInstances         #-}
{-# LANGUAGE MultiParamTypeClasses     #-}
{-# LANGUAGE ScopedTypeVariables       #-}
{-# LANGUAGE StandaloneDeriving        #-}
{-# LANGUAGE TypeFamilies              #-}
{-# LANGUAGE TypeOperators             #-}
{-# LANGUAGE UndecidableInstances      #-}

#if PROFILE_CORESIZE
{-# OPTIONS_GHC -ddump-to-file -ddump-ds-preopt -ddump-ds -ddump-simpl #-}
#endif
#if PROFILE_TIMING
{-# OPTIONS_GHC -ddump-to-file -ddump-timings #-}
#endif

{-# OPTIONS_GHC -fplugin=Data.Record.Plugin #-}

module HigherKinded.Sized.R010 where

import Bench.Types

{-# ANN type R largeRecord #-}
data R f = MkR {
      -- 1 .. 10
      field1  :: HK 1  f
    , field2  :: HK 2  f
    , field3  :: HK 3  f
    , field4  :: HK 4  f
    , field5  :: HK 5  f
    , field6  :: HK 6  f
    , field7  :: HK 7  f
    , field8  :: HK 8  f
    , field9  :: HK 9  f
    , field10 :: HK 10 f
    }
  deriving (Eq, Show)

-- Complains about
--
-- > No instance for (Data.Functor.Classes.Show1 f)
-- >   arising from a use of ‘show’
--
-- which is what we want: @ghc@ has simplified all 10 constraints on each
-- individual field (generated by 'largeRecord') to a single constraint on @r@.
--
-- TODO: We should test this with docspec.
--
-- checkInferredType :: R f -> String
-- checkInferredType = show
