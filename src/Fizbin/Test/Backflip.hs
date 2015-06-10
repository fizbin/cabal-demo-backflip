{-# LANGUAGE TupleSections #-}

-- | A module to test out some quirks of cabal packaging.
-- Backflip implements a way complicated version of "reverse".

module Fizbin.Test.Backflip
       ( backflip
       )
       where
import Control.Applicative ((<$>))
import Control.Monad.ST (ST, runST)
import Control.Monad (forM_)
import Data.Array.MArray (newListArray, readArray, writeArray, getElems)
import Data.Array.ST (STArray)

backflip :: [a] -> [a]
backflip a' = runST (toArray a' >>= inplaceReverse >>= getElems)
  where
    toArray :: [a] -> ST s (Int, STArray s Int a)
    toArray a = let l = length a
                in (l,) <$> newListArray (1, l) a
    inplaceReverse (l, a) = do
      forM_ [1..l `div` 2] $ \i ->
        do x <- readArray a i
           y <- readArray a (l + 1 - i)
           writeArray a i y
           writeArray a (l + 1 - i) x
      return a
