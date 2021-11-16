module Main

import Control.Comonad
import Control.Comonad.Store.Representable
import Conway
import Data.Functor.Representable
import Data.Vect
import System

%default total

covering
main : IO ()
main = loop conway $ mkGrid {n = 12, m = 12}
  [ (1, 0), (2, 1), (0, 2), (1, 2), (2, 2) -- glider
  , (9, 5), (10, 5), (11, 5) -- blinker
  ]
  where
    loop : {n : Nat} -> {m : Nat} -> Rule n m -> Grid n m Bool -> IO ()
    loop r g = do
      putStr "\ESC[2J"
      putStr $ showGrid g
      usleep 100000
      loop r $ g =>> r
