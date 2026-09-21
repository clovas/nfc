{ lib, nixosModules, ... }:
{
  imports = with nixosModules; [
    preset-desktop
  ];
  services = {
    upower.enable = true;
    tlp.enable = true;
    power-profiles-daemon.enable = lib.mkForce false;
    udev.extraRules = ''
      ACTION=="add|change", ENV{ID_INPUT_TOUCHPAD}=="1", ENV{LIBINPUT_IGNORE_DEVICE}="1"
    '';
  };
}
