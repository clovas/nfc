{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
    ];
    fontconfig = {
      defaultFonts = {
        emoji = [ "Noto Color Emoji" ];
        monospace = [
          "DejaVu Sans Mono"
          "Noto Sans Mono CJK SC"
        ];
        sansSerif = [
          "DejaVu Sans"
          "Noto Sans CJK SC"
        ];
        serif = [
          "DejaVu Serif"
          "Noto Serif CJK SC"
        ];
      };
    };
  };
}
