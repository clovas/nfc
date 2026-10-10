{ nixosModules, ... }:
{
  imports = with nixosModules; [
    preset-base
    serial
    ddns
    proxy-server
    tun4
  ];

  swapDevices = [
    {
      device = "/.swapfile";
      size = 1024;
    }
  ];

  boot.loader.efi.canTouchEfiVariables = false;

  users.users.saya.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPgeTw/EkeCAiENeV02mMMXDFnmVBhEjkb9VM7wh6fKi saya@gohei"
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPgeTw/EkeCAiENeV02mMMXDFnmVBhEjkb9VM7wh6fKi saya@gohei"
  ];
}
