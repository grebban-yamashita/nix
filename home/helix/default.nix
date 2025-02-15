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
            php83
            php83Extensions.dom
            php83Extensions.filter
            php83Extensions.simplexml
            php83Extensions.tokenizer
            php83Packages.psalm
          ])
        ];
    });
    # Psalm requires the following PHP extensions to be installed: dom, filter, simplexml, tokenizer.
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

          sticky-context = {
            enable = true;
            indicator = true;
            max-lines = 10;
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
        language-server = {
          psalm = {
            command = "${pkgs.php83}/bin/php";
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
              name = "vscode-php-debug";
              command = "node";
              args = ["${pkgs.vscode-extensions.xdebug.php-debug}/share/vscode/extensions/xdebug.php-debug/out/phpDebug.js"];
              templates = [{
                name = "Listen for XDebug";
                request = "launch";
                completion = "ignored";
                args = {};
              }];
            }
          }
          {
            name = "gdscript";
            language-servers = ["gdscript-lsp"];
          }
        ];
      };

  };
}
