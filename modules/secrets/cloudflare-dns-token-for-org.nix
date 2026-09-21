{ inputs, ... }:
{
  sops.secrets = {
    cloudflare-dns-token-for-org = {
      sopsFile = "${inputs.self}/modules/secrets/cloudflare-dns-token-for-org.yaml";
    };
  };
}
