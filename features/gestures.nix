# Feature: gestures
# Mouse gestures (gesture-nvim) — disabled.
{ config, pkgs, lib, ... }: {
  config.vim.gestures.gesture-nvim.enable = false;
}
