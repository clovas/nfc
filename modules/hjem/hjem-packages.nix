{ pkgs, ... }:
{
  hjem.users.saya.packages = with pkgs; [
    pdfpc
    freerdp
  ];
}
