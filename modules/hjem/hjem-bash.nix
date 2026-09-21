{ ... }:
{
  hjem.users.saya = {
    files = {
      ".bashrc".text = ''
        for f in ~/.bashrc.d/*.sh; do
          [ -r "$f" ] && source "$f"
        done
      '';

      ".bash_profile".text = ''
        [[ -f ~/.bashrc ]] && . ~/.bashrc
      '';
    };
  };
}
