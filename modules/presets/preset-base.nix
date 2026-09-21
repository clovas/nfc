{ nixosModules, ... }:
{
  imports = with nixosModules; [
    gnupg
    hjem
    hjem-bash
    hjem-neovim
    packages
    direnv
    neovim
    git
    starship
    secrets
    bash
    boot
    tmux
    services
    system
    user
  ];
}
