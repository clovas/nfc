{ pkgs, ... }:
{
  hjem.users.saya.packages =
    let
      nvim = pkgs.wrapNeovimUnstable pkgs.neovim-unwrapped {
        wrapRc = false;
        plugins = with pkgs.vimPlugins; [
          modus-themes-nvim
          indent-blankline-nvim
          telescope-nvim
          blink-cmp
          plenary-nvim
          nvim-lspconfig
        ];
      };
    in
    with pkgs;
    [
      nvim
    ];
  hjem.users.saya = {
    files = {
      ".config/nvim/init.lua".source = ./init.lua;
    };
  };
}
