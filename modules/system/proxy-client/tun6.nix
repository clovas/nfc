{ config, ... }:
{
  sops.secrets."tun6.conf" = {
    sopsFile = ./tun6.conf;
    format = "binary";
  };
  networking.wg-quick.interfaces.cfwg6.configFile = config.sops.secrets."tun6.conf".path;
}
