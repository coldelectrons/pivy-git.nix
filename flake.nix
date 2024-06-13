{
  description = "Coin3d pivy package from git";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    flake-utils.url = github:numtide/flake-utils;
  };

  outputs = {nixpkgs, flake-utils, ...}:
    flake-utils.lib.eachDefaultSystem (
      system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in rec {
          packages =  {
            default = pkgs.callPackage ./pivy.nix {
              inherit pkgs;
              inherit (pkgs) lib;
              inherit (pkgs.python312Packages) buildPythonPackage;
              inherit (pkgs.libsForQt5)
                qtbase
                qmake
                soqt;
            };
          };
          devShells =  {
            default = let
              inherit (packages.${pkgs.system}) default;
              inherit (pkgs) lib mkShell;
            in
              mkShell {
                inputsFrom = [default];
              };
          };
    });
}
