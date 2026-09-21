{ inputs, ... }:
{
  sops.secrets = {
    "ssh-github" = {
      sopsFile = "${inputs.self}/modules/secrets/ssh-github.yaml";
    };
  };
}
