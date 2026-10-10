{ config, ... }:
{
  sops.secrets."tun4.conf" = {
    sopsFile = ./tun4.conf;
    format = "binary";
  };
  networking.wg-quick.interfaces.cfwg4.configFile = config.sops.secrets."tun4.conf".path;
}
