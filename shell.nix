{ pkgs ? import ./nixpkgs.nix }:
let
  inherit (pkgs) mkShell spago purescript aws-sam-cli nodejs entr;
  package = import ./. { inherit pkgs; };
  yarn = pkgs.yarn.override { nodejs = pkgs.nodejs; };
in mkShell {
  buildInputs = [
    package
    yarn
    nodejs
    spago
    purescript
    aws-sam-cli
    entr
  ];
}
