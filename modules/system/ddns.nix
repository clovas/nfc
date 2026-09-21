{
  config,
  lib,
  pkgs,
  hostProps,
  nixosModules,
  ...
}:
{
  imports = with nixosModules; [
    cloudflare-dns-token-for-me
  ];

  services.ddclient =
    let
      domain = "radicate.me";
    in
    {
      enable = true;
      protocol = "cloudflare";
      username = "token";
      passwordFile = config.sops.secrets.cloudflare-dns-token-for-me.path;
      zone = domain;
      domains = [ "${hostProps.hostName}.${domain}" ];

      usev4 = lib.mkDefault "cmdv4, cmdv4=${pkgs.writeShellScript "get-v4" ''
        ${pkgs.iproute2}/bin/ip -4 addr show scope global | ${pkgs.gawk}/bin/awk '/inet / && !/ (10\.|172\.(1[6-9]|2[0-9]|3[01])\.|192\.168\.|169\.254\.|100\.(6[4-9]|[7-9][0-9]|1[01][0-9]|12[0-7])\.|198\.(1[89])\.)/ {split($2, a, "/"); print a[1]; exit}'
      ''}";

      usev6 = lib.mkDefault "cmdv6, cmdv6=${pkgs.writeShellScript "get-v6" ''
        ${pkgs.iproute2}/bin/ip -6 addr show scope global | ${pkgs.gnugrep}/bin/grep -vP "temporary|deprecated" | ${pkgs.gawk}/bin/awk '/inet6 / {split($2, a, "/"); if (a[1] !~ /^(fd|fe80)/) {print a[1]; exit}}'
      ''}";

      interval = "5min";
      ssl = true;
    };
}
