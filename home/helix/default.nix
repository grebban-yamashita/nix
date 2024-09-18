{
  helix-master,
  pkgs,
  ...
}: {
  programs.helix = {
    enable = true;
    package = helix-master.packages.${pkgs.system}.default.overrideAttrs (old: {
      makeWrapperArgs = with pkgs;
        old.makeWrapperArgs
        or []
        ++ [
          "--suffix"
          "PATH"
          ":"
          (lib.makeBinPath [
            clang-tools
            marksman
            nodePackages.vscode-langservers-extracted
            shellcheck
            php83Packages.psalm
          ])
        ];
    });
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
            args = ["${pkgs.vscode-extensions.xdebug.php-debug}/share/vscode/extensions/xdebug.php-debug/out/phpDebug.js"];
            transport = "tcp";
            port-arg = "--server={}";
          }
        ];
        language-server = {
          psalm = {
            command = "php";
            args = ["${pkgs.php83Packages.psalm}/bin/psalm-language-server"];
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
          # {
          #   name = "nix";
          #   language-servers = ["alejandra"];
          # }
          {
            name = "gdscript";
            language-servers = ["gdscript-lsp"];
          }
        ];
      };

  };
}
