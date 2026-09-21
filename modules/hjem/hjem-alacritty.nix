{ pkgs, ... }:
{
  hjem.users.saya.packages = with pkgs; [
    alacritty
  ];

  hjem.users.saya.files.".config/alacritty/alacritty.toml" = {
    generator = (pkgs.formats.toml { }).generate "alacritty.toml";
    value = {
      general.import = [ "${pkgs.alacritty-theme}/modus_vivendi.toml" ];
      window = {
        opacity = 0.8;
      };
    };
  };
}
