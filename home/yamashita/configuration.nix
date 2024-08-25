{ config
, pkgs
, ... }:

{
  users.users."yamashita" = {               # macOS user
    home = "/Users/yamashita";
    shell = pkgs.zsh;                     # Default shell
  };

  system.defaults.dock.persistent-apps = [
    "/Applications/Safari.app"
    "/Users/yamashita/Applications/Home Manager Apps/WezTerm.app"
    "/Users/yamashita/Applications/Home Manager Apps/TablePlus.app"
  ];

  homebrew.casks = [
    "google-japanese-ime"
    "librewolf"
    "unclack"
  ];
}
