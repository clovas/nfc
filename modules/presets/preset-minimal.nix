{ nixosModules, ... }:
{
  imports = with nixosModules; [
    boot
    services
    system
    user
  ];
}
