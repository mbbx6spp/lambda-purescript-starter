{ pkgs ? import ./nixpkgs.nix }:
import ./yarn.nix {
  inherit (pkgs.yarn2nix-moretea) mkYarnPackage;
}
