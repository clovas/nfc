{ pkgs, inputs, ... }:
{
  imports = [ inputs.sops-nix.nixosModules.sops ];
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  environment.systemPackages = [
    (pkgs.writeShellScriptBin "sops" ''
      if [ -z "''${SOPS_AGE_KEY_CMD:-}" ]; then
        SOPS_AGE_KEY_CMD="sudo ${pkgs.ssh-to-age}/bin/ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key" \
          exec ${pkgs.sops}/bin/sops "$@"
      else
        exec ${pkgs.sops}/bin/sops "$@"
      fi
    '')
  ];
}
