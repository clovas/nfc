{ inputs, ... }:
{
  imports = [
    inputs.hjem.nixosModules.default
  ];

  hjem = {
    users.saya = {
      directory = "/home/saya";
    };
  };
}
