{ pkgs
, lib
, ...
}:

{
  language-server = {
    tailwindcss-react = {
      command = "hx-tw";
      args = ["--stdio"];
      roots = ["tailwind.config.js" "tailwind.config.cjs" ".prettierrc" "nx.json"];
    };
    eslint = {
      command = "vscode-eslint-language-server";
      args = ["--stdio"];
    };
    typescript-language-server = {
      command = "typescript-language-server";
      args = ["--stdio"];
    };
  };
  language = [
    {
      name = "tsx";
      scope = "tsx";
      injection-regex = "(tsx)";
      file-types = ["tsx"];
      language-servers = [
        "typescript-language-server"
        "tailwindcss-react"
        "eslint"
      ];
      roots = ["tailwind.config.js"];
    }
    {
      name = "typescript";
      scope = "source.ts";
      injection-regex = "(ts|typescript)";
      file-types = ["ts"];
      language-servers = [
        "typescript-language-server"
        "tailwindcss-react"
        "eslint"
      ];
      roots = ["tailwind.config.js"];
    }
    {
      name = "javascript";
      scope = "source.js";
      injection-regex = "(js|javascript)";
      file-types = ["js"];
      language-servers = [
        "typescript-language-server"
        "tailwindcss-react"
        "eslint"
      ];
      roots = ["tailwind.config.js"];
    }
  ];
}
