{
  inputs,
  nixosModules,
  mkImport,
  ...
}:
let
  mkHost =
    { hostName }:
    let
      hostProps = import ./hosts/${hostName}/_hostProps.nix;
      nvfetcher = import ./_sources/generated.nix {
        inherit (inputs.nixpkgs.legacyPackages.${hostProps.system})
          fetchurl
          fetchgit
          fetchFromGitHub
          dockerTools
          ;
      };
    in
    inputs.nixpkgs.lib.nixosSystem {
      system = hostProps.system;
      specialArgs = {
        inherit
          inputs
          hostProps
          nixosModules
          mkImport
          nvfetcher
          ;
      };
      modules = mkImport ./hosts/${hostName};
    };
in
{
  suzu = mkHost {
    hostName = "suzu";
  };
  hari = mkHost {
    hostName = "hari";
  };
  ofuda = mkHost {
    hostName = "ofuda";
  };
  sakaki = mkHost {
    hostName = "sakaki";
  };
  gohei = mkHost {
    hostName = "gohei";
  };
  omamori = mkHost {
    hostName = "omamori";
  };
}
