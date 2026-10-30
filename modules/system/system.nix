{ hostProps, inputs, ... }:
{
  imports = [ inputs.disko.nixosModules.disko ];
  system.stateVersion = hostProps.stateVersion;
  time.timeZone = "Asia/Singapore";
  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [ "@wheel" ]; # `root` is included by default
  };
  networking.hostName = hostProps.hostName;
}
