{ config
, pkgs
, ... }:

{
  users.users."work" = {               # macOS user
    home = "/Users/work";
    shell = pkgs.zsh;                     # Default shell
  };

  system.defaults.dock.persistent-apps = [
    "/Applications/Safari.app"
    "/Users/work/Applications/Home Manager Apps/kitty.app"
    "/Users/work/Applications/Home Manager Apps/TablePlus.app"
  ];

  homebrew.casks = [
    "1password"
    "asana"
    "docker"
    "firefox"
    "rapidapi"
    "slack"
    "dbngin"
    "unclack"
    "sublime-merge@dev"
  ];
}
