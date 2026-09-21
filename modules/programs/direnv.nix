{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.direnv = {
    enable = true;
    enableBashIntegration = false;
  };

  # https://github.com/direnv/direnv/pull/1439
  programs.bash.interactiveShellInit = ''
    if ${lib.boolToString config.programs.direnv.loadInNixShell} || { [ -z "$IN_NIX_SHELL$NIX_GCROOT" ] && [[ ! "$PATH" =~ "/nix/store" ]]; }; then
      _DIRENV_RAW_HOOK=$(${pkgs.direnv}/bin/direnv hook bash)
      _TARGET='if [[ ";''${PROMPT_COMMAND[*]:-};" != *";_direnv_hook;"* ]]; then'
      _REPLACEMENT='if [[ "''${BLE_VERSION-}" && $_ble_version -ge 400 ]]; then blehook PRECMD!="_direnv_hook"; elif [[ ";''${PROMPT_COMMAND[*]:-};" != *";_direnv_hook;"* ]]; then'
      _MODIFIED_HOOK=''${_DIRENV_RAW_HOOK/"$_TARGET"/"$_REPLACEMENT"}
      if [ "$_DIRENV_RAW_HOOK" != "$_MODIFIED_HOOK" ]; then
        eval "$_MODIFIED_HOOK"
      else
        echo "Error: Failed to patch direnv hook for ble.sh compatibility." >&2
      fi
      unset _DIRENV_RAW_HOOK _MODIFIED_HOOK _TARGET _REPLACEMENT
    fi
  '';
}
