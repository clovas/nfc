{
  config,
  lib,
  nixosModules,
  ...
}:
{
  imports = with nixosModules; [
    preset-base
    proxy-server
    ddns
    podman
  ];

  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.efi.canTouchEfiVariables = false;

  swapDevices = [
    {
      device = "/.swapfile";
      size = 1024;
    }
  ];

  networking.firewall = {
    allowedTCPPorts = [
      37645
      22
      2222
      23
      2323
    ];
  };

  services.openssh = lib.mkIf config.services.openssh.enable {
    ports = [ 37645 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "prohibit-password";
    };
  };

  users.users.saya.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHPCUX4bSiN1vOnncWIPeOsKHvW4zyE2iz/eSgDwWs5E saya@gohei"
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHPCUX4bSiN1vOnncWIPeOsKHvW4zyE2iz/eSgDwWs5E saya@gohei"
  ];
}
