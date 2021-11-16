module Conway

import Control.Comonad
import Control.Comonad.Store.Representable
import Data.Functor.Representable
import Data.List
import Data.String
import Data.Vect

%default total

public export
Grid : Nat -> Nat -> Type -> Type
Grid n m = Store (Vect n . Vect m) {rep = Compose}

public export
Coord : Nat -> Nat -> Type
Coord n m = (Fin n, Fin m)

public export
Rule : Nat -> Nat -> Type
Rule n m = Grid n m Bool -> Bool

public export
mkGrid : {n : Nat} -> {m : Nat} -> List (Coord (S n) (S m)) -> Grid (S n) (S m) Bool
mkGrid coords = store @{Compose} (`elem` coords) (0, 0)

public export
showGrid : Grid n m Bool -> String
showGrid (MkStore xss _) = unlines . map (foldMap (bool "." "#")) . toList $ xss
  where
    bool : a -> a -> Bool -> a
    bool x y = \case
      True => y
      False => x

public export
conway : {n : Nat} -> {m : Nat} -> Rule n m
conway g =
  (alive && (aliveCount == 2 || aliveCount == 3)) || (not alive && aliveCount == 3)
  where
    alive : Bool
    alive = extract g

    incWrap : {n : Nat} -> Fin n -> Fin n
    incWrap {n = S _} x = fromMaybe FZ . strengthen $ FS x

    sucWrap : {n : Nat} -> Fin n -> Fin n
    sucWrap {n = 0} _ impossible
    sucWrap FZ = last
    sucWrap (FS x) = weaken x

    neighbors : (Fin n, Fin m) -> List (Fin n, Fin m)
    neighbors (x, y) =
      [ (incWrap x, sucWrap y), (incWrap x, y), (incWrap x, incWrap y)
      , (x,         sucWrap y),                 (x,         incWrap y)
      , (sucWrap x, sucWrap y), (sucWrap x, y), (sucWrap x, incWrap y)
      ]

    aliveCount : Nat
    aliveCount = length . filter id . experiment neighbors $ g
