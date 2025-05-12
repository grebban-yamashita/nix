{
  lib, 
  pkgs,
  inputs,
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
          default-command = ["log-recent"];
          merge-editor = ["/opt/homebrew/bin/smerge" "mergetool" "$base" "$left" "$right" "-o" "$output"];
        };
        revset-aliases = {
          "closest_bookmark(to)" = "heads(::to & bookmarks())";
          "closest_pushable(to)" = "heads(::to & ~description(exact:'') & (~empty() | merges()))";
          "recent()" = "committer_date(after:'3 months ago')";
        };
        snapshot.max-new-file-size = "10MiB";
        git = {
          auto-local-bookmark = true;
        };
        template-aliases = {
          "format_short_change_id(id)" = "id.shortest()";
          "format_short_signature(signature)" = "signature.email().local()";
          "format_timestamp(timestamp)" = "timestamp.ago()";
        };
        templates = {
          # "log" = ''
          #   if(root,
          #     format_root_commit(self),
          #     label(if(current_working_copy, "working_copy"),
          #       concat(
          #         separate(" ",
          #           format_short_change_id_with_hidden_and_divergent_info(self),
          #           if(empty, label("empty", "(empty)")),
          #           if(description,
          #             description.first_line(),
          #             label(if(empty, "empty"), description_placeholder),
          #           ),
          #           bookmarks,
          #           tags,
          #           working_copies,
          #           if(git_head, label("git_head", "HEAD")),
          #           if(conflict, label("conflict", "conflict")),
          #           if(config("ui.show-cryptographic-signatures").as_boolean(),
          #             format_short_cryptographic_signature(signature)),
          #         ) ++ "\n",
          #       ),
          #     )
          #   )
          # '';
          # "log_node" = ''
          #   label("node",
          #     coalesce(
          #       if(!self, label("elided", "~")),
          #       if(current_working_copy, label("working_copy", "@")),
          #       if(conflict, label("conflict", "×")),
          #       if(immutable, label("immutable", "*")),
          #       label("normal", "·")
          #     )
          #   )
          # '';
        };
        user = {
          name = "grebban-yamashita";
          email = "linus@grebban.com";
        };
        aliases = {
          sl = ["log" "-r" "trunk():: ~ (remote_bookmarks() ~ bookmarks()) | (@..bookmarks())" "--no-pager" "--reversed"];
          log-recent = ["log" "-r" "::@ & recent()"];
          tug = ["bookmark" "move" "--from" "closest_bookmark(@)" "--to" "closest_pushable(@)"];
        };
      };
    };

    helix = {
      enable = true;
      package = inputs.helix.packages.${pkgs.system}.default;
      settings = {
        theme = "catppuccin_latte";

        editor = {
          bufferline = "multiple";
          color-modes = true;
          completion-trigger-len = 3;
          end-of-line-diagnostics = "hint";
          indent-guides.character = "┊";
          indent-guides.render = true;
          line-number = "relative";

          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };

          inline-diagnostics = {
            cursor-line = "error";
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
              u = ":write";
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
            formatter = {
              command = "./vendor/bin/pint";
              args = ["--stdin" "--stdin-filename %{buffer_name}"];
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
      enable = true;
      extraConfig = ''
        # Default GitHub (used for grebban-yamashita)
        Host github.com
          HostName github.com
          User git
          IdentityFile ~/.ssh/id_ed25519
          IdentitiesOnly yes
          UseKeychain yes
          AddKeysToAgent yes

        # Separate identity for yamashitax
        Host github.com-yamashita
          HostName github.com
          User git
          IdentityFile ~/.ssh/id_ed25519_yamashita
          IdentitiesOnly yes
          UseKeychain yes
          AddKeysToAgent yes
      '';
    };

    zsh.enable = true;
  };

  home = {
    file = {
      ".config/helix/themes".source = "${inputs.catppuccin-helix}/themes/default";
      ".config/ghostty/config".text = ''
        theme = "dark:catppuccin-frappe,light:catppuccin-latte"
        font-family = "JetBrains Mono"
        font-size = 11
        macos-option-as-alt = true
        cursor-style = block
      '';
      ".config/direnv/direnvrc".text = ''
        use_jj-yamashita() {
          export JJ_USER="山下"
          export JJ_EMAIL="git@yamashit.ax"
        }
      '';
    };
    stateVersion = "24.11";
  };
}
