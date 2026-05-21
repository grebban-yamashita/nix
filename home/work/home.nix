{
  extensions,
  lib, 
  pkgs,
  inputs,
  ampSkills,
  ... 
}: 
let
  commonExtensions = { all, ... }: with all; [
    bcmath calendar ctype curl dom exif fileinfo filter ftp
    gd gettext gmp iconv imap intl ldap mbstring mysqli mysqlnd
    openssl pcntl pdo_mysql pdo_pgsql pdo_sqlite pgsql posix
    readline session soap sockets sodium sqlite3 sysvsem
    tokenizer xmlreader xmlwriter zip zlib
  ];

  # PHP without xdebug (default `php`)
  phpBase = pkgs.php.buildEnv {
    extensions = commonExtensions;
    extraConfig = ''
      upload_max_filesize = 10M
      post_max_size = 20M
    ''; # Add if you want any baseline PHP.ini values
  };

  # PHP with xdebug in debug mode
  phpDebug = pkgs.php.buildEnv {
    extensions = { all, ... }: (commonExtensions { inherit all; }) ++ [ all.xdebug ];
    extraConfig = ''
      xdebug.collect_params=On
      xdebug.connect_timeout_ms=200
      xdebug.discover_client_host=Off
      xdebug.idekey="vscode"
      xdebug.mode=debug
      xdebug.start_with_request=yes
    '';
  };

  # PHP with xdebug in profile mode
  phpProfile = pkgs.php.buildEnv {
    extensions = { all, ... }: (commonExtensions { inherit all; }) ++ [ all.xdebug ];
    extraConfig = ''
      xdebug.collect_params=On
      xdebug.connect_timeout_ms=200
      xdebug.discover_client_host=Off
      xdebug.idekey="vscode"
      xdebug.mode=profile
      xdebug.start_with_request=yes
    '';
  };

  # PHP with xdebug in profile mode
  phpCoverage = pkgs.php.buildEnv {
    extensions = { all, ... }: (commonExtensions { inherit all; }) ++ [ all.xdebug ];
    extraConfig = ''
      xdebug.collect_params=On
      xdebug.connect_timeout_ms=200
      xdebug.discover_client_host=Off
      xdebug.idekey="vscode"
      xdebug.mode=coverage
      xdebug.start_with_request=yes
    '';
  };

  # Wrapper scripts with clear names
  phpDebugWrapper = pkgs.writeShellScriptBin "php-debug" ''
    exec ${phpDebug}/bin/php "$@"
  '';

  phpProfileWrapper = pkgs.writeShellScriptBin "php-profile" ''
    exec ${phpProfile}/bin/php "$@"
  '';

  phpCoverageWrapper = pkgs.writeShellScriptBin "php-coverage" ''
    exec ${phpCoverage}/bin/php "$@"
  '';
in
{
  imports = [ ../common.nix ];

  home.packages = with pkgs; [
    awscli
    asciinema
    bat
    eza
    fd
    fzf
    gh
    htop
    httpie
    jq
    jsonfmt
    ripgrep
    sentry-cli
    tree

    podman
    podman-compose

    maccy

    opentofu

    ssm-session-manager-plugin

    flyctl

    raycast

    devenv
    inputs.nix-vscode-extensions.extensions.aarch64-darwin.open-vsx.getpsalm.psalm-vscode-plugin
    intelephense
    nodejs

    phpBase             # `php` (no xdebug)
    phpDebugWrapper     # `php-debug`
    phpProfileWrapper   # `php-profile`
    phpCoverageWrapper   # `php-coverage`

    phpPackages.composer

    # inputs.ghostty.packages.aarch64-darwin.default

    delta

    colima
    lima
    rectangle
    sensible-side-buttons
    tableplus
    # vscode-extensions.devsense.profiler-php-vscode
    vscode-extensions.xdebug.php-debug
    vscode-langservers-extracted
    zigpkgs."master"
    zls
  ];

  home.file.".php.ini".text = ''
    [Xdebug]
    zend_extension="xdebug.so"
  '';

  home.file.".gitconfig".text = ''
    [includeIf "gitdir:/Users/work/Developer/yamashita/**"]
        path = .yamashita.gitconfig

    [includeIf "gitdir:/Users/work/Developer/**"]
        path = .grebban.gitconfig
  '';

  home.file.".grebban.gitconfig".text = ''
    [core]
      sshCommand = "ssh -i ~/.ssh/id_ed25519 -o IdentitiesOnly=yes"
    [user]
        name = grebban-yamashita
        email = linus@grebban.com
  '';

  home.file.".yamashita.gitconfig".text = ''
    [core]
      sshCommand = "ssh -i ~/.ssh/id_ed25519_yamashita -o IdentitiesOnly=yes"
    [user]
      name = "山下"
      email = git@yamashit.ax
  '';

  home.file.".amp/skills".source = ampSkills;
}
