# Feature: completion
# Autocompletion engine (nvim-cmp, blink-cmp) and snippet engine (luasnip).
{ config, pkgs, lib, ... }: {
  config.vim = {
    autocomplete = {
      nvim-cmp = {
        enable = true;
        sources = {
          nvim-cmp = null;
          buffer = "[Buffer]";
          path = "[Path]";
        };
        sourcePlugins = [
          "codecompanion-nvim"
        ];
      };
      blink-cmp.friendly-snippets.enable = true;
    };

    snippets.luasnip.enable = true;

    # Extra plugins for cmp sources
    extraPlugins = with pkgs.vimPlugins; {
      # "cmp-path" = {
      #   package = cmp-path;
      # };
    };
  };
}
