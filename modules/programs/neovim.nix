{ ... }:
{
  programs.neovim.enable = true;
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
