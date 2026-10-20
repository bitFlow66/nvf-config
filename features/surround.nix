# Feature: surround
# Add, change, and remove surrounding pairs using the standard ys/ds/cs grammar.
{
  config,
  pkgs,
  lib,
  ...
}: {
  config.vim.utility.surround = {
    enable = true;
    useVendoredKeybindings = false;
    setupOpts.keymaps = {
      normal = "ys";
      normal_cur = "yss";
      normal_line = "yS";
      normal_cur_line = "ySS";
      visual = "S";
      visual_line = "gS";
      delete = "ds";
      change = "cs";
      change_line = "cS";
    };
  };
}
