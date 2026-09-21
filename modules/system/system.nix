{ hostProps, inputs, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];
  system.stateVersion = hostProps.stateVersion;
  time.timeZone = "Asia/Singapore";
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];
  networking.hostName = hostProps.hostName;
}
