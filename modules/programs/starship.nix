{ ... }:
{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;

      format =
        let
          direnv = "(\\($direnv\\))";
          nix_shell = "(\\($nix_shell\\))";

          time = "($time )";
          directory = "($directory )";
          git = "(\\($git_branch( $git_status)\\) )";
          character = "($character )";
        in
        "(${direnv}${nix_shell}\n)${time}${directory}${git}${character}";

      nix_shell = {
        disabled = false;
        format = "[$symbol $state]($style)";
        style = "white";
        symbol = "nix";
        impure_msg = "*";
        pure_msg = ".";
      };

      direnv = {
        disabled = false;
        format = "[$symbol $loaded$allowed]($style)";
        style = "white";
        symbol = "direnv";
        allowed_msg = "v";
        not_allowed_msg = "!";
        denied_msg = "x";
        loaded_msg = "+";
        unloaded_msg = "-";
      };

      time = {
        disabled = false;
        format = "[$time]($style)";
        style = "purple";
        time_format = "%T";
        use_12hr = false;
      };

      directory = {
        disabled = false;
        format = "[$path]($style)";
        style = "bold cyan";
        truncation_length = 100;
        truncate_to_repo = false;
      };

      git_branch = {
        disabled = false;
        format = "[$branch]($style)";
        style = "bold green";
        symbol = "";
      };

      git_status = {
        disabled = false;
        format = "[$all_status$ahead_behind]($style)";
        style = "bold yellow";
        stashed = "\\$";
        modified = "*";
        staged = "+";
        untracked = "%";
        conflicted = "!";
        renamed = "-";
        deleted = "x";
        typechanged = "^";

        ahead = ">";
        behind = "<";
        diverged = "<>";
        up_to_date = "=";
      };

      character = {
        disabled = false;
        format = "$symbol";
        success_symbol = "[\\$](bold green)";
        error_symbol = "[\\$](bold red)";
      };
    };
  };
}
