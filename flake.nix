{
  description = "Conway's game of life";

  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.idris2-pkgs.url = "github:claymager/idris2-pkgs";

  outputs = { self, nixpkgs, idris2-pkgs, flake-utils }:
    flake-utils.lib.eachSystem [ "x86_64-darwin" "x86_64-linux" "i686-linux" ] (system:
      let
        pkgs = import nixpkgs { inherit system; overlays = [ idris2-pkgs.overlay ]; };
        inherit (pkgs.idris2-pkgs._builders) idrisPackage devEnv;
        conway = idrisPackage ./. { };
        runTests = idrisPackage ./test { extraPkgs.conway = conway; };
      in
      {
        defaultPackage = conway;

        packages = { inherit conway runTests; };

        devShell = pkgs.mkShell {
          buildInputs = [ (devEnv conway) ];
        };
      }
    );
}
