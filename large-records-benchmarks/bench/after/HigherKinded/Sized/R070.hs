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

module HigherKinded.Sized.R070 where

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
      -- 11 .. 20
    , field11 :: HK 11 f
    , field12 :: HK 12 f
    , field13 :: HK 13 f
    , field14 :: HK 14 f
    , field15 :: HK 15 f
    , field16 :: HK 16 f
    , field17 :: HK 17 f
    , field18 :: HK 18 f
    , field19 :: HK 19 f
    , field20 :: HK 20 f
      -- 21 .. 30
    , field21 :: HK 21 f
    , field22 :: HK 22 f
    , field23 :: HK 23 f
    , field24 :: HK 24 f
    , field25 :: HK 25 f
    , field26 :: HK 26 f
    , field27 :: HK 27 f
    , field28 :: HK 28 f
    , field29 :: HK 29 f
    , field30 :: HK 30 f
      -- 31 .. 40
    , field31 :: HK 31 f
    , field32 :: HK 32 f
    , field33 :: HK 33 f
    , field34 :: HK 34 f
    , field35 :: HK 35 f
    , field36 :: HK 36 f
    , field37 :: HK 37 f
    , field38 :: HK 38 f
    , field39 :: HK 39 f
    , field40 :: HK 40 f
      -- 41 .. 50
    , field41 :: HK 41 f
    , field42 :: HK 42 f
    , field43 :: HK 43 f
    , field44 :: HK 44 f
    , field45 :: HK 45 f
    , field46 :: HK 46 f
    , field47 :: HK 47 f
    , field48 :: HK 48 f
    , field49 :: HK 49 f
    , field50 :: HK 50 f
      -- 51 .. 60
    , field51 :: HK 51 f
    , field52 :: HK 52 f
    , field53 :: HK 53 f
    , field54 :: HK 54 f
    , field55 :: HK 55 f
    , field56 :: HK 56 f
    , field57 :: HK 57 f
    , field58 :: HK 58 f
    , field59 :: HK 59 f
    , field60 :: HK 60 f
      -- 61 .. 70
    , field61 :: HK 61 f
    , field62 :: HK 62 f
    , field63 :: HK 63 f
    , field64 :: HK 64 f
    , field65 :: HK 65 f
    , field66 :: HK 66 f
    , field67 :: HK 67 f
    , field68 :: HK 68 f
    , field69 :: HK 69 f
    , field70 :: HK 70 f
    }
  deriving (Eq, Show)
