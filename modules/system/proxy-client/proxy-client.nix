{
  config,
  lib,
  pkgs,
  nvfetcher,
  ...
}:
let
  sb-static =
    let
      arch = if pkgs.stdenv.hostPlatform.isAarch64 then "arm64" else "amd64";
    in
    pkgs.runCommand "sing-box-static"
      {
        inherit (nvfetcher."sing-box-static-${arch}") src;
        meta.mainProgram = "sing-box";
      }
      ''
        mkdir -p $out/bin
        tar xf $src -C $out/bin --strip-components=1 sing-box-*/sing-box
      '';
in
{
  sops.secrets."sing-box.json" = {
    sopsFile = ./sing-box.json;
    format = "json";
    owner = "sing-box";
    key = "";
  };
  sops.secrets."xray.json" = {
    sopsFile = ./xray.json;
    format = "json";
    key = "";
  };

  networking.firewall = lib.mkIf config.networking.firewall.enable {
    checkReversePath = "loose";
  };

  services.xray = {
    enable = true;
    settingsFile = config.sops.secrets."xray.json".path;
  };

  services.sing-box = {
    enable = true;
    package = sb-static;
  };
  systemd.packages = [ pkgs.sing-box ];
  services.dbus.packages = [ pkgs.sing-box ];
  systemd.services.sing-box = {
    after = [ "xray.service" ];
    bindsTo = [ "xray.service" ];
    serviceConfig = {
      ExecStart = [
        ""
        "${sb-static}/bin/sing-box -D \${STATE_DIRECTORY} -c ${
          config.sops.secrets."sing-box.json".path
        } run"
      ];
    };
  };

  environment = {
    variables = {
      SBOX_CONTROLLER_PORT = "8964";
    };
    systemPackages =
      let
        sbox = pkgs.writeShellScriptBin "sbox" ''
          COMMAND=$1
              shift
              case "$COMMAND" in
                "set")
                  GROUP=$1
                  NODE=$2
                  if [ -z "$GROUP" ] || [ -z "$NODE" ]; then
                    echo "Error: Missing arguments."
                    echo "Usage: sbox set <group> <node>"
                    exit 1
                  fi
                  ENCODED_GROUP=$(echo "$GROUP" | sed 's/ /%20/g')
                  ${pkgs.curl}/bin/curl -f -X PUT "http://127.0.0.1:$SBOX_CONTROLLER_PORT/proxies/$ENCODED_GROUP" \
                    -H "Content-Type: application/json" \
                    -d "{\"name\":\"$NODE\"}"
                  ;;
                "restart")
                  sudo systemctl restart sing-box
                  ;;
                "start")
                  sudo systemctl start sing-box
                  ;;
                "stop")
                  sudo systemctl stop sing-box
                  ;;
                "status")
                  systemctl status sing-box
                  ;;
                *)
                  echo "Usage: sbox {set <group> <node>|start|stop|restart|status}"
                  exit 1
                  ;;
              esac
        '';
      in
      [ sbox ];
  };
}
