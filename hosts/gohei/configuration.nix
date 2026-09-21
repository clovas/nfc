{
  lib,
  pkgs,
  nixosModules,
  ...
}:
{
  imports = with nixosModules; [
    preset-laptop
    proxy-client
    tor
    ssh-ofuda
    ssh-hari
    ssh-github
  ];

  environment.systemPackages = with pkgs; [
    quickemu
  ];

  sops.secrets = {
    "ssh-ofuda" = {
      owner = "saya";
      mode = "0400";
    };
    "ssh-hari" = {
      owner = "saya";
      mode = "0400";
    };
    "ssh-github" = {
      owner = "saya";
      mode = "0400";
    };
  };

  systemd.services.tor.wantedBy = lib.mkForce [ ];
  services.tor.settings = {
    UseBridges = true;
    ClientTransportPlugin = "snowflake exec ${pkgs.snowflake}/bin/client";
    Bridge = "snowflake 192.0.2.3:80 2B280B23E1107BB62ABFC40DDCC8824814F80A72 fingerprint=2B280B23E1107BB62ABFC40DDCC8824814F80A72 url=https://1098762253.rsc.cdn77.org front=www.phpmyadmin.net,cdn.zk.mk ice=stun:stun.antisip.com:3478,stun:stun.epygi.com:3478,stun:stun.uls.co.za:3478,stun:stun.voipgate.com:3478,stun:stun.mixvoip.com:3478,stun:stun.nextcloud.com:3478,stun:stun.bethesda.net:3478,stun:stun.nextcloud.com:443 utls-imitate=hellorandomizedalpn";
  };

  hjem.users.saya.files = {
    ".config/hypr/hyprland/gpu.lua".text = ''
      hl.env("AQ_DRM_DEVICES", "/dev/dri/intel-igpu:/dev/dri/nvidia-dgpu")
    '';
    ".ssh/config".text = ''
      Host *
          ServerAliveInterval 30
          ServerAliveCountMax 3
      Host ofuda
          HostName ofuda.radicate.me
          User saya
          Port 37645
          IdentityFile /run/secrets/ssh-ofuda
      Host hari 
          HostName hari.radicate.me
          User saya
          Port 22
          IdentityFile /run/secrets/ssh-hari
      Host github
          HostName github.com 
          User git 
          Port 22
          IdentityFile /run/secrets/ssh-github
    '';
  };

  environment.etc."wireplumber/wireplumber.conf.d/alsa-soft-mixer.conf".text = ''
    monitor.alsa.rules = [
      {
        matches = [
          {
            device.name = "alsa_card.usb-ASUSTeK_COMPUTER_INC._C-Media_R__Audio-00"
          }
        ]
        actions = {
          update-props = {
            # Do not use the hardware mixer for volume control. It
            # will only use software volume. The mixer is still used
            # to mute unused paths based on the selected port.
            api.alsa.soft-mixer = true
          }
        }
      }
    ]
  '';

  services.tlp = {
    enable = true;
    settings = {
      START_CHARGE_THRESH_BAT1 = 55;
      STOP_CHARGE_THRESH_BAT1 = 60;
    };
  };
}
