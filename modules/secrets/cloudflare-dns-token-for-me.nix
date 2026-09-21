{ inputs, ... }:
{
  sops.secrets = {
    cloudflare-dns-token-for-me = {
      sopsFile = "${inputs.self}/modules/secrets/cloudflare-dns-token-for-me.yaml";
    };
  };
}
