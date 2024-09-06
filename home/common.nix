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
  ... 
}: 

{
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
      package = pkgs.helix;
      settings = {
        theme = "catppuccin_latte";

        editor = {
          color-modes = true;
          bufferline = "multiple";
          completion-trigger-len = 3;
          line-number = "relative";
          indent-guides.render = true;
          indent-guides.character = "┊";

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };

          whitespace.render = {
            space = "all";
            tab = "all";

            nbsp = "none";
            nnbsp = "none";
            newline = "none";
          };
        };

        keys = {
          normal = {
            space = {
              e = ":write";
              q = ":quit";
              space = "goto_last_accessed_file";
            };
          };
        };
      };

      languages = {
        debugger = [
          {
            name = "xdebug";
            command = "node";
            args = ["${pkgs.vscode-extensions.xdebug.php-debug}/out/phpDebug.js"];
            transport = "tcp";
            port-arg = "--server={}";
          }
        ];
        language-server = {
          psalm = {
            command = "php";
            args = ["./vendor/bin/psalm-language-server"];
          };
          gdscript-lsp = {
            command = "nc";
            args = ["127.0.0.1" "6005"];
          };
        };
        language = [
          {
            name = "php";
            indent = {
              tab-width = 4;
              unit = "    ";
            };
            language-servers = ["intelephense" "psalm"];
            debugger = {
              name = "xdebug";
              command = "node";
              args = ["${pkgs.vscode-extensions.xdebug.php-debug}/out/phpDebug.js"];
              transport = "tcp";
              port-arg = "--server={}";
              templates = [{
                name = "listen";
                request = "launch";
                completion = [ { name = "binary"; completion = "filename"; } ];
                args = { log = true; };
              }];
            };
          }
          {
            name = "nix";
            language-servers = ["alejandra"];
          }
          {
            name = "gscript";
            language-servers = ["gdscript-lsp"];
          }
        ];
      };
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
