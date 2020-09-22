{ pkgs ? import ./nixpkgs.nix }:
let
  inherit (pkgs) mkShell spago purescript aws-sam-cli nodejs-12_x entr;
  package = import ./. { inherit pkgs; };
  yarn = pkgs.yarn.override { nodejs = pkgs.nodejs-12_x; };
in mkShell {
  buildInputs = [
    package
    yarn
    nodejs-12_x
    spago
    purescript
    aws-sam-cli
    entr
  ];
}
