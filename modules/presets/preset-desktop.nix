{ nixosModules, ... }:
{
  imports = with nixosModules; [
    preset-base
    fonts
    graphical-general
    hyprland
    bluetooth
    pipewire
    hjem-alacritty
    hjem-hyprland
    hjem-packages
  ];
  services.flatpak.enable = true;
}
