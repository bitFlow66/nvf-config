# Feature: ui
# Visual appearance: theme, statusline, dashboard, tabline, borders, and
# decorative plugins.
{
  config,
  pkgs,
  lib,
  ...
}: {
  config.vim = {
    theme = {
      enable = true;
      name = "catppuccin";
      style = "mocha";
      transparent = false;
    };

    statusline.lualine = {
      enable = true;
      setupOpts.options.theme = "catppuccin";
      integrations.breadcrumbs = {
        navbuddy.enable = true;
        nvim-navic.enable = true;
      };
    };

    visuals = {
      nvim-scrollbar.enable = true;
      nvim-web-devicons.enable = true;
      nvim-cursorline.enable = true;
      cinnamon-nvim.enable = true;
      fidget-nvim.enable = true;
      highlight-undo.enable = true;
      indent-blankline.enable = true;
    };

    dashboard.startify = {
      enable = true;
      changeToVCRoot = true;
    };

    tabline.nvimBufferline = {
      enable = true;
      setupOpts.options.numbers = "none";
      mappings = {
        cycleNext = "<S-l>";
        cyclePrevious = "<S-h>";
        closeCurrent = "<leader>bx";
      };
    };

    notify.nvim-notify.enable = true;

    ui = {
      borders.enable = true;
      noice.enable = false;
      colorizer.enable = true;
      modes-nvim.enable = false; # the theme looks terrible with catppuccin
      illuminate.enable = true;
      smartcolumn = {
        enable = true;
        setupOpts.custom_colorcolumn = {
          nix = "110";
          ruby = "120";
          java = "130";
          go = ["90" "130"];
        };
      };
      fastaction.enable = true;
    };
  };
}
