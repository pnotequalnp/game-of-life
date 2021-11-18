module Main

import Control.Comonad
import Control.Comonad.Store.Representable
import Conway
import Conway.Parse
import Data.Fuel
import Data.Functor.Representable
import Data.Vect
import System
import System.File.ReadWrite
import System.File.Virtual

%default total

fRead : HasIO io => File -> Fuel -> io String
fRead file fuel = foldMap id <$> go file fuel
  where
    go : File -> Fuel -> io (List String)
    go file Dry = pure []
    go file (More fuel) = do
      False <- fEOF file | _ => pure []
      Right str <- fGetLine file | _ => pure []
      putStrLn "Hello"
      (str ::) <$> go file fuel

covering
main : IO ()
main = do
  text <- fRead stdin forever
  case parseGrid text of
    Nothing => putStrLn "Invalid starting position"
    Just ((n, m) ** grid) => loop conway grid
  where
    loop : {n : Nat} -> {m : Nat} -> Rule n m -> Grid n m Bool -> IO ()
    loop r g = do
      putStr "\ESC[2J"
      putStr $ showGrid g
      usleep 500000
      loop r $ g =>> r
