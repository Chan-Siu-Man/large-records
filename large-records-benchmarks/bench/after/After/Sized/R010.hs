{-# LANGUAGE ConstraintKinds           #-}
{-# LANGUAGE DataKinds                 #-}
{-# LANGUAGE ExistentialQuantification #-}
{-# LANGUAGE FlexibleContexts          #-}
{-# LANGUAGE FlexibleInstances         #-}
{-# LANGUAGE MultiParamTypeClasses     #-}
{-# LANGUAGE ScopedTypeVariables       #-}
{-# LANGUAGE StandaloneDeriving        #-}
{-# LANGUAGE TemplateHaskell           #-}
{-# LANGUAGE TemplateHaskell           #-}
{-# LANGUAGE TypeFamilies              #-}
{-# LANGUAGE UndecidableInstances      #-}

#if PROFILE_CORESIZE
{-# OPTIONS_GHC -ddump-to-file -ddump-ds-preopt -ddump-ds -ddump-simpl #-}
#endif
#if PROFILE_TIMING
{-# OPTIONS_GHC -ddump-to-file -ddump-timings #-}
#endif

module After.Sized.R010 where

import Data.Aeson (ToJSON(..))

import Data.Record.Generic.JSON
import Data.Record.TH

import Bench.Types

largeRecord defaultLazyOptions [d|
    data R = MkR {
          -- 1 .. 10
          field1  :: T 1
        , field2  :: T 2
        , field3  :: T 3
        , field4  :: T 4
        , field5  :: T 5
        , field6  :: T 6
        , field7  :: T 7
        , field8  :: T 8
        , field9  :: T 9
        , field10 :: T 10
        }
      deriving (Eq, Show)
  |]

instance ToJSON R where
  toJSON = gtoJSON
