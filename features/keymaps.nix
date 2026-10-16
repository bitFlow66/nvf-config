# Feature: keymaps
# Shared visual indentation bindings.
{
  config,
  pkgs,
  lib,
  ...
}: {
  config.vim.keymaps = [
    # Visual mode — move highlighted lines and re-highlight
    {
      key = ">";
      mode = "v";
      silent = true;
      action = "><CR>gv";
    }
    {
      key = "<";
      mode = "v";
      silent = true;
      action = "<<CR>gv";
    }
  ];
}
