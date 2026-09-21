{ pkgs, ... }:
{
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 22 ];
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
