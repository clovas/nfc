{ inputs, ... }:
{
  sops.secrets = {
    "ssh-ofuda" = {
      sopsFile = "${inputs.self}/modules/secrets/ssh-ofuda.yaml";
    };
  };
}
