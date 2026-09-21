{ inputs, ... }:
{
  sops.secrets = {
    "ssh-hari" = {
      sopsFile = "${inputs.self}/modules/secrets/ssh-hari.yaml";
    };
  };
}
