# Game of Life
Conway's game of life implemented in terms of the store comonad in Idris 2 using representable
functors. The current implementation wraps to create an infinite world.

## Design
A function `w a -> b` for some comonad `w` can be thought of as a "query" over some context relative
to some position within that context. Comonads allow us to "extend" that query to all possible
positions. If the universe is thought of as the context, and a particular cell thought of as a
position, then you could write a query `Grid Bool -> Bool` to determine the liveness of a single
cell according to some rule regarding its neighbors. The nature of comonads then allows us to extend
that query to ask the liveness of every possible cell. The main loop of the game of life can be
implemented by recursively extending that rule over the universe indefinitely. Conceptually, this
would look something like:

```idris
runLife rule universe = runLife rule (universe =>> rule) 
```

However, some extra bookkeeping is required to render the intermediate states and ensure totality.

## Running
The starting position is expected to be input via stdin. Acceptable format is a rectangular
arrangement of characters. Alive cells are indicated with a `#`. The simulation continues
indefinitely and must be manually killed (such as with ctrl-c). Some example starting positions are
given in the `examples` directory.

### Nix
```bash
nix run github:pnotequalnp/game-of-life < startingPosition.txt
```

### Manual
```bash
git clone https://github.com/pnotequalnp/game-of-life.git
cd game-of-life
idris2 --build
./build/exec/conway < examples/glider.txt
```
