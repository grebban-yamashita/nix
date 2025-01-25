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
    "/Applications/Ghostty.app"
    "/Users/work/Applications/Home Manager Apps/TablePlus.app"
  ];

  homebrew.casks = [
    "1password"
    "asana"
    "betterdisplay"
    "dbngin"
    "docker"
    "firefox"
    "ghostty"
    "obsidian"
    "rapidapi"
    "slack"
    "sublime-merge@dev"
    "unclack"
    "whisky"
  ];
}
