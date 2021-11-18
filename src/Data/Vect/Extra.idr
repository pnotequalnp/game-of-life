module Data.Vect.Extra

import Data.Vect

%default total

public export
asVect : List a -> (n : Nat ** Vect n a)
asVect [] = (0 ** [])
asVect (x :: xs) = let (n ** xs') = asVect xs in (S n ** x :: xs')

public export
mapWithIndex : (Fin n -> a -> b) -> Vect n a -> Vect n b
mapWithIndex f = \case
  [] => []
  x :: xs => f FZ x :: mapWithIndex (f . FS) xs
