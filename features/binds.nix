# Feature: binds
# Keybinding helpers: which-key popup and cheatsheet.
{ config, pkgs, lib, ... }: {
  config.vim.binds = {
    whichKey.enable = true;
    cheatsheet.enable = true;
  };
}
