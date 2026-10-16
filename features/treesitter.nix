# Feature: treesitter
# Shared parsers and syntax-aware text objects.
{
  config,
  pkgs,
  lib,
  ...
}: {
  config.vim.treesitter = {
    enable = true;
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
      setupOpts.select.lookahead = true;
    };
  };

  # NVF's textobjects module still emits the legacy setup API.
  config.vim.pluginRC.treesitter-textobjects = lib.mkForce (
    lib.nvim.dag.entryAfter ["treesitter"] ''
      require("nvim-treesitter-textobjects").setup(${lib.nvim.lua.toLuaObject config.vim.treesitter.textobjects.setupOpts})
    ''
  );

  config.vim.keymaps = [
    {
      key = "af";
      mode = ["x" "o"];
      desc = "Select function";
      lua = true;
      action = ''function() require("nvim-treesitter-textobjects.select").select_textobject("@function.outer", "textobjects") end'';
    }
    {
      key = "if";
      mode = ["x" "o"];
      desc = "Select inside function";
      lua = true;
      action = ''function() require("nvim-treesitter-textobjects.select").select_textobject("@function.inner", "textobjects") end'';
    }
    {
      key = "ac";
      mode = ["x" "o"];
      desc = "Select class";
      lua = true;
      action = ''function() require("nvim-treesitter-textobjects.select").select_textobject("@class.outer", "textobjects") end'';
    }
    {
      key = "ic";
      mode = ["x" "o"];
      desc = "Select inside class";
      lua = true;
      action = ''function() require("nvim-treesitter-textobjects.select").select_textobject("@class.inner", "textobjects") end'';
    }
  ];
}
