{
  lib,
  pkgs,
  nixosModules,
  nvfetcher,
  ...
}:
{
  imports = with nixosModules; [
    preset-base
    tor
    proxy-client
  ];

  systemd.services.tor.wantedBy = lib.mkForce [ ];

  boot.loader.efi.canTouchEfiVariables = false;
}
