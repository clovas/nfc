{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    (pkgs.pass.withExtensions (exts: [ exts.pass-otp ]))
    nvfetcher
    zip
    unzip
    _7zz
    unar
    file
    wget
    tree
    lsof
    just
    jq
    pciutils
    gost
    aria2
    fd
    ripgrep
    convco
  ];
}
