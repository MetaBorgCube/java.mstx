{ nixpkgs ? import <nixpkgs> {} }:

let
  inherit (nixpkgs) pkgs;
  inherit (pkgs) haskellPackages;

  haskellDeps = ps: with ps; [
    base
    mtl
    parsec
    shake
    strip-ansi-escape
    regex-base
    regex-tdfa
  ];

  ghc = haskellPackages.ghcWithPackages haskellDeps;

  nixPackages = [
    ghc
    haskellPackages.cabal-install
  ];
in

pkgs.stdenv.mkDerivation {
  name = "test-runner";
  buildInputs = nixPackages;
}