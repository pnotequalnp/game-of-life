module Data.Functor.Representable

import Data.Vect
import Data.Vect.Extra

%default total

public export
interface Functor f => Representable f rep | f where
  index : f a -> rep -> a
  tabulate : (rep -> a) -> f a

public export
[Compose] Representable f rep => Representable g rep' => Representable (f . g) (rep, rep') using Functor.Compose where
  index x (i, j) = (x `index` i) `index` j
  tabulate = map tabulate . tabulate . curry

public export
{n : Nat} -> Representable (Vect n) (Fin n) where
  index = flip index
  tabulate f = mapWithIndex (\i, () => f i) $ replicate n ()
