{
  lib, 
  pkgs,
  inputs,
  ... 
}: 

let
  pkgsUnstable = import <unstable>;
in
{
  nixpkgs.overlays = [
    (final: previous: {
      helix = inputs.helix;
    })
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
      # package = inputs.jujutsu.packages.aarch64-darwin.jj;
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
      # package = inputs.helix.packages.aarch64-darwin;
      # package = inputs.helix.packages.aarch64-darwin.helix.overrideAttrs (old: {
      #   makeWrapper = with pkgs;
      #   old.makeWrapperArgs
      #   or []
      #   ++ [
      #     "--suffix"
      #     "PATH"
      #     ":"
      #     (lib.makeBinPath [
      #       marksman
      #       nodePackages.vscode-langservers-extracted
      #       nodePackages.intelephense
      #       php83
      #       php83Extensions.dom
      #       php83Extensions.filter
      #       php83Extensions.simplexml
      #       php83Extensions.tokenizer
      #       php83Packages.composer
      #       vscode-extensions.xdebug.php-debug
      #       vscode-extensions.devsense.profiler-php-vscode
      #     ])
      #   ];
      # });
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
            name = "psalm";
            command = "${pkgs.php83Packages.psalm}/bin/psalm-language-server";
            args = [ "--verbose" "--config=/Users/work/psalm/psalm.xml" ];
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
              name = "vscode-php-debug";
              transport = "stdio";
              command = "node";
              args = [ "${pkgs.vscode-extensions.xdebug.php-debug}/share/vscode/extensions/xdebug.php-debug/out/phpDebug.js" ];
              templates = [{
                name = "listen";
                request = "launch";
                completion = [ "ignored" ];
                args = { log = true; };
              }];
            };
          }
          {
            name = "nix";
            language-servers = ["alejandra"];
          }
          {
            name = "gdscript";
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
      themeFile = "Catppuccin-Latte";
    };

    zsh.enable = true;
  };

  home = {
    file.".config/helix/themes".source = "${inputs.catppuccin-helix}/themes/default";
    stateVersion = "24.05";
  };
}
