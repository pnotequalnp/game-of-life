module Conway.Parse

import Conway
import Control.Comonad.Store.Representable
import Data.Functor.Representable
import Data.List
import Data.String
import Data.Vect
import Data.Vect.Extra

%default total

toVect : {n : Nat} -> AsList s -> Maybe (Vect n Char)
toVect {n = 0} Nil = Just []
toVect {n = S m} (c :: s) = (c ::) <$> toVect s
toVect _ = Nothing

parseLine : {n : Nat} -> String -> Maybe (List (Fin n))
parseLine str = findIndices (== '#') <$> toVect (asList str)

export
parseGrid : String -> Maybe (DPair (Nat, Nat) (\(n, m) => Grid n m Bool))
parseGrid text = do
  (S n ** rows) <- pure $ asVect (lines text) | _ => Nothing
  S m <- pure $ length (head rows) | _ => Nothing
  coords' <- traverse (parseLine {n = S m}) rows
  let coords = foldMap id $ mapWithIndex (\i, c => (i,) <$> c) coords'
  pure $ ((S n, S m) ** store @{Compose} (`elem` coords) (0, FZ))
