{
  extensions,
  lib, 
  pkgs,
  ... 
}: 
{
  imports = [ ../common.nix ];

  home.packages = with pkgs; [
    algolia-cli
    bun
    devenv
    fd
    nodePackages.intelephense
    nodejs
    rectangle
    sensible-side-buttons
    tableplus
    vscode-extensions.xdebug.php-debug
  ];
}
