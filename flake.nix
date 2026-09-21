{
  description = "NFC";

  outputs =
    inputs:
    let
      inherit (import ./lib { inherit inputs; }) mkImport mkModule;
      nixosModules = mkModule ./modules;
    in
    {
      inherit nixosModules;
      nixosConfigurations = import ./nixosConfigurations.nix { inherit inputs nixosModules mkImport; };
    };

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.xz";

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
