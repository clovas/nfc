update:
  nvfetcher
  nix flake update --flake .

deploy:
  sudo nixos-rebuild switch --flake .

boot:
  sudo nixos-rebuild boot --flake . 

gc:
  sudo nix store gc --debug
  sudo nix-collect-garbage --delete-old

updatekeys:
  #!/usr/bin/env bash
  for path in $(grep 'path_regex:' .sops.yaml | awk '{print $3}' | sed 's/^\^//; s/\$$//'); do
      sops updatekeys -y $path
  done
