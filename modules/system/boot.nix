{ lib, hostProps, ... }:
let
  bootCases = {
    systemd-boot = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = lib.mkDefault true;
    };
    grub = {
      grub = {
        enable = true;
        efiSupport = true;
        efiInstallAsRemovable = lib.mkDefault false;
      };
      efi.canTouchEfiVariables = lib.mkDefault true;
    };
  };
  selectedConfig = bootCases.${hostProps.bootMode} or { };
in
{
  assertions = [
    {
      assertion = bootCases ? ${hostProps.bootMode};
      message = "Error! Invalid bootMode: '${hostProps.bootMode}'. Must be one of: ${lib.concatStringsSep ", " (builtins.attrNames bootCases)}";
    }
  ];
  boot = {
    loader = selectedConfig;
    kernelModules = [ "tcp_bbr" ];
    kernel.sysctl = {
      "kernel.sysrq" = 1;
      "net.core.default_qdisc" = "fq";
      "net.ipv4.tcp_congestion_control" = "bbr";
    };
  };
}
