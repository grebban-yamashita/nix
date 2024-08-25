{
  extensions,
  lib, 
  pkgs,
  ... 
}: 
{
  imports = [ ../common.nix ];

  programs = {
    git.userEmail = "hello@yamashit.ax";
    git.userName = "山下";

    jujutsu.settings.user = {
      name = "山下";
      email = "git@yamashit.ax";
    };
  };
}
