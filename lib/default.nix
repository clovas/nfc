{ inputs }:
let
  lib = inputs.nixpkgs.lib;
  mkImport = import ./mkImport.nix { inherit lib; };
  mkModule = import ./mkModule.nix { inherit lib mkImport; };
in
{
  inherit mkImport mkModule;
}
