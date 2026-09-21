{ ... }:
{
  programs.bash = {
    enable = true;
    blesh.enable = true;
    interactiveShellInit = ''
      bleopt prompt_ps1_final='\n\t \$ '
    '';
    shellAliases = {
      ansissh = "TERM=ansi ssh";
    };
  };
}
