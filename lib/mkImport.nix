{ lib }:
let
  inherit (lib) hasPrefix;
  inherit (lib.fileset) toList fileFilter;
in
path: toList (fileFilter (f: f.hasExt "nix" && !(hasPrefix "_" f.name)) path)
