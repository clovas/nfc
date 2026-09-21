{ lib, mkImport }:
let
  inherit (builtins) unsafeDiscardStringContext listToAttrs;
  inherit (lib) removeSuffix splitString last;
in
path:
listToAttrs (
  map (a: {
    name = unsafeDiscardStringContext (removeSuffix ".nix" (last (splitString "/" a)));
    value = import a;
  }) (mkImport path)
)
