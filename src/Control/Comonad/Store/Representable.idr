module Control.Comonad.Store.Representable

import Control.Comonad
import public Control.Comonad.Store.Interface
import Data.Functor.Representable

%default total

public export
data Store : (f : Type -> Type) -> {rep : Representable f r} -> Type -> Type where
  MkStore : {0 rep : Representable f r} -> f a -> r -> Store {rep} f a

public export
(rep : Representable f r) => Functor (Store f {rep}) where
  map f (MkStore s i) = MkStore (map f s) i

public export
(rep : Representable f r) => Comonad (Store f {rep}) where
  extract (MkStore s i) = s `index` i
  duplicate (MkStore s i) = MkStore (tabulate (MkStore s)) i

public export
(rep : Representable f r) => ComonadStore r (Store {rep} f) where
  pos (MkStore _ i) = i
  peek i (MkStore s _) = s `index` i

public export
store : (rep : Representable f r) => (r -> a) -> r -> Store {rep} f a
store g i = MkStore (tabulate g) i
