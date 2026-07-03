# Feature: git
# Git integration: gitsigns (inline blame/diff) and general git enablement.
{ config, pkgs, lib, ... }: {
  config.vim.git = {
    enable = true;
    gitsigns.enable = true;
    gitsigns.codeActions.enable = false; # throws an annoying debug message
  };
}
