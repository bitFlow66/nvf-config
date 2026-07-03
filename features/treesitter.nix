# Feature: treesitter
# Treesitter context and textobjects (select function/class boundaries).
{ config, pkgs, lib, ... }: {
  config.vim.treesitter = {
    context.enable = true;
    textobjects = {
      enable = true;
      setupOpts = {
        select = {
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
  };
}
