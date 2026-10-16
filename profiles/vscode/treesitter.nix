# VS Code profile: text objects without Neovim-owned highlighting or context UI.
{
  config,
  pkgs,
  lib,
  ...
}: {
  config.vim.treesitter = {
    enable = true;
    highlight.enable = false;
    indent.enable = false;
    grammars = let
      inherit
        (pkgs.vimPlugins.nvim-treesitter.grammarPlugins)
        bash
        c
        cpp
        c_sharp
        lua
        markdown
        markdown_inline
        nix
        python
        razor
        rust
        vim
        vimdoc
        yaml
        zig
        ;
    in [
      bash
      c
      cpp
      c_sharp
      lua
      markdown
      markdown_inline
      nix
      python
      razor
      rust
      vim
      vimdoc
      yaml
      zig
    ];
    textobjects = {
      enable = true;
      setupOpts.select = {
        enable = true;
        keymaps = {
          "af" = {
            query = "@function.outer";
            desc = "function";
          };
          "if" = {
            query = "@function.inner";
            desc = "function";
          };
          "ac" = {
            query = "@class.outer";
            desc = "class";
          };
          "ic" = {
            query = "@class.inner";
            desc = "class";
          };
        };
        lookahead = true;
      };
    };
  };
}
