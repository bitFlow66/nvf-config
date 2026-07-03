# Feature: minimap
# Code minimap (codewindow) — disabled pending upstream fix.
# See: https://github.com/gorbit99/codewindow.nvim/pull/86
{ config, pkgs, lib, ... }: {
  config.vim.minimap.codewindow.enable = false;
}
