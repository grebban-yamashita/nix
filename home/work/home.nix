{
  extensions,
  lib, 
  pkgs,
  inputs,
  ... 
}: 
{
  imports = [ ../common.nix ];

  home.packages = with pkgs; [
    algolia-cli
    bun
    devenv
    fd
    nodejs
    rectangle
    php83
    # php83Packages.composer
    nodePackages.intelephense
    sensible-side-buttons
    tableplus
    vscode-extensions.xdebug.php-debug
    vscode-extensions.devsense.profiler-php-vscode
  ];
}
