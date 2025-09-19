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

  system.primaryUser = "work";

  homebrew.brews = [
    "openssl@3"
  ];

  homebrew.casks = [
    "1password"
    "cmux"
    "dbngin"
    "firefox"
    "helium-browser"
    "obsidian"
    "slack"
    "sublime-merge@dev"
    "unclack"
  ];
}
