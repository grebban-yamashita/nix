{
  extensions,
  lib, 
  pkgs,
  inputs,
  ... 
}: 
let
  pkgs_unstable = import (builtins.fetchGit {
      name = "master";
      url = "https://github.com/NixOS/nixpkgs/";
      ref = "refs/heads/nixpkgs-unstable";
      rev = "62cfb3e8d8b15ed71217b68c526ea3ecefd6acc2";
  }) {
    inherit (pkgs) system;
  };

  myPhp = pkgs.php83.buildEnv {
    extensions = { all, ... }: with all; [
      bcmath
      calendar
      ctype
      curl
      dom
      exif
      fileinfo
      filter
      ftp
      gd
      gettext
      gmp
      iconv
      imap
      intl
      ldap
      mbstring
      mysqli
      mysqlnd
      openssl
      pcntl
      pdo_mysql
      pdo_pgsql
      pdo_sqlite
      pgsql
      posix
      readline
      session
      soap
      sockets
      sodium
      sqlite3
      sysvsem
      tokenizer
      xdebug
      xmlreader
      xmlwriter
      zip
      zlib
    ];
    extraConfig = ''
      xdebug.collect_params=On
      xdebug.connect_timeout_ms=200
      xdebug.discover_client_host=Off
      xdebug.idekey="vscode"
      xdebug.mode=debug
      xdebug.start_with_request=yes
    '';
  };
in
{
  imports = [ ../common.nix ];

  home.packages = with pkgs; [
    asciinema
    bat
    eza
    fd
    fzf
    gh
    htop
    httpie
    jsonfmt
    jq
    ripgrep
    sentry-cli
    tree
    
    devenv
    inputs.nix-vscode-extensions.extensions.aarch64-darwin.open-vsx.getpsalm.psalm-vscode-plugin
    nodePackages.intelephense
    nodejs
    myPhp
    php83Packages.composer

    colima
    lima
    rectangle
    sensible-side-buttons
    tableplus
    vscode-extensions.devsense.profiler-php-vscode
    vscode-extensions.xdebug.php-debug
    vscode-langservers-extracted
    zigpkgs."master"
  ];

  home.file.".php.ini".text = ''
    [Xdebug]
    zend_extension="xdebug.so"
  '';
}
