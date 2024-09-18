{
  devenv,
  lib, 
  nil,
  pkgs,
  zig,
  helix-master,
  nixpkgs,
  catppuccin-helix,
  runCommand,
  inputs,
  ... 
}: 

{
  imports = [
    ./helix
  ];
  programs = {
    direnv.enable = true;

    fzf.enable = true;

    git ={
      enable = true;
      ignores = [
        ".DS_Store"
        ".devenv"
        ".direnv"
        ".envrc"
      ];
    };

    jujutsu = {
      enable = true;
      settings = {
        ui = {
          editor = "hx";
          default-command = "log";
          merge-editor = ["/opt/homebrew/bin/smerge" "mergetool" "$base" "$left" "$right" "-o" "$output"];
        };
        snapshot.max-new-file-size = "10MiB";
        git = {
          auto-local-branch = true;
        };
        template-aliases = {
          "format_short_signature(signature)" = "signature.username()";
          "format_short_id(id)" = "id.shortest()";
        };
        user = {
          name = "grebban-yamashita";
          email = "linus@grebban.com";
        };
      };
    };

    helix = {
      enable = true;
    };

    ripgrep = {
      enable = true;
    };
  
    ssh = {
      extraConfig = ''
        Host *
          UseKeychain yes
          AddKeysToAgent yes
          IdentityFile ~/.ssh/id_ed25519
      '';
    };

    kitty = {
      enable = true;
      font.name = "JetBrains Mono";
      theme = "Catppuccin-Latte";
    };

    zsh.enable = true;
  };

  home = {
    file.".config/helix/themes".source = "${catppuccin-helix}/themes/default";
    stateVersion = "24.05";
  };
}
