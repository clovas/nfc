{ nixosModules, nvfetcher, ... }:
{
  imports = with nixosModules; [
    preset-base
    proxy-client
    tor
    "${nvfetcher.nixos-hardware.src}/common/gpu/nvidia/disable.nix"
  ];

  boot.kernelParams = [
    "consoleblank=60"
  ];

  systemd.services.tor.wantedBy = lib.mkForce [ ];
  services.tor.settings = {
    UseBridges = true;
    ClientTransportPlugin = "snowflake exec ${pkgs.snowflake}/bin/client";
    Bridge = "snowflake 192.0.2.3:80 2B280B23E1107BB62ABFC40DDCC8824814F80A72 fingerprint=2B280B23E1107BB62ABFC40DDCC8824814F80A72 url=https://1098762253.rsc.cdn77.org front=www.phpmyadmin.net,cdn.zk.mk ice=stun:stun.antisip.com:3478,stun:stun.epygi.com:3478,stun:stun.uls.co.za:3478,stun:stun.voipgate.com:3478,stun:stun.mixvoip.com:3478,stun:stun.nextcloud.com:3478,stun:stun.bethesda.net:3478,stun:stun.nextcloud.com:443 utls-imitate=hellorandomizedalpn";
  };
}
