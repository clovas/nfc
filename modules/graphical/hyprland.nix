{ ... }:
{
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  security.polkit.enable = true;
  security.pam.services.waylock = { };
  services.udisks2.enable = true;
}
