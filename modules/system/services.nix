{ config, lib, pkgs, ... }:
{
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
  };

  networking = {
    nameservers = lib.mkDefault [ "1.1.1.1" "1.0.0.1" "2606:4700:4700::1111" "2606:4700:4700::1001" ];
    dhcpcd.extraConfig = lib.mkIf config.networking.dhcpcd.enable "nohook resolv.conf";
    networkmanager.dns = lib.mkIf config.networking.networkmanager.enable "none";
  };

  services.zram-generator = {
    enable = true;
    settings = {
      zram0 = {
        zram-size = "ram * 2";
        zram-resident-limit = "ram / 2";
        compression-algorithm = "zstd";
        swap-priority = 100;
      };
    };
  };

  services.openssh.enable = true;

  systemd.sleep.settings.Sleep = {
    AllowSuspend = "no";
    AllowHibernation = "no";
    AllowHybridSleep = "no";
    AllowSuspendThenHibernate = "no";
  };
}
