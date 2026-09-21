{
  config,
  pkgs,
  nixosModules,
  hostProps,
  inputs,
  ...
}:
{
  imports = with nixosModules; [
    cloudflare-dns-token-for-me
  ];

  sops.secrets = {
    "sing-box.json" = {
      sopsFile = "${inputs.self}/hosts/${hostProps.hostName}/sing-box.json";
      format = "json";
      key = "";
    };
    "xray.json" = {
      sopsFile = "${inputs.self}/hosts/${hostProps.hostName}/xray.json";
      format = "json";
      key = "";
    };
  };

  sops.templates."cloudflare-dns-token-for-me.env".content = ''
    CLOUDFLARE_DNS_API_TOKEN=${config.sops.placeholder.cloudflare-dns-token-for-me}
  '';

  security.acme =
    let
      domain = "radicate.me";
    in
    {
      acceptTerms = true;
      certs."${hostProps.hostName}.${domain}" = {
        email = "admin@${domain}";
        dnsProvider = "cloudflare";
        postRun = ''
          systemctl --no-block restart sing-box.service
          systemctl --no-block restart xray.service
        '';
        environmentFile = config.sops.templates."cloudflare-dns-token-for-me.env".path;
      };
    };

  services.sing-box = {
    enable = true;
  };

  systemd.services.sing-box = {
    serviceConfig = {
      ExecStart = [
        ""
        "${pkgs.sing-box}/bin/sing-box -D \${STATE_DIRECTORY} -c ${
          config.sops.secrets."sing-box.json".path
        } run"
      ];
    };
  };

  services.xray = {
    enable = true;
    settingsFile = config.sops.secrets."xray.json".path;
  };

  systemd.services.xray.serviceConfig.SupplementaryGroups = [ "acme" ];

  networking.firewall = {
    allowedTCPPorts = [
      2053
      2083
    ];
    allowedUDPPorts = [
      2053
    ];
  };
}
