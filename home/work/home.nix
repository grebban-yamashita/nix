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
    asciinema
    bat
    eza
    fd
    fzf
    htop
    jq
    ripgrep
    sentry-cli
    tree
    
    devenv
    # inputs.packages.jj.aarch64-darwin.jujutsu
    inputs.nix-vscode-extensions.extensions.aarch64-darwin.open-vsx.getpsalm.psalm-vscode-plugin
    nodePackages.intelephense
    nodejs
    php83
    rectangle
    sensible-side-buttons
    tableplus
    vscode-extensions.devsense.profiler-php-vscode
    vscode-extensions.xdebug.php-debug
    # zls
  ];
}
