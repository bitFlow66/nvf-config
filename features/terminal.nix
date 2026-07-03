# Feature: terminal
# Terminal management: toggleterm with lazygit integration.
{ config, pkgs, lib, ... }: {
  config.vim.terminal.toggleterm = {
    enable = true;
    lazygit.enable = true;
  };
}
