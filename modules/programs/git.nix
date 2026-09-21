{ ... }:
{
  programs.git = {
    enable = true;
    config = {
      user.name = "Clovas";
      user.email = "clovas@radicate.me";
    };
  };
}
