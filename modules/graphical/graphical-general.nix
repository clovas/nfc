{ ... }:
{
  programs.uwsm.enable = true;
  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];
}
