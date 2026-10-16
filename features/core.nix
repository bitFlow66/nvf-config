# Feature: core
# Basic Neovim behaviour: aliases, clipboard, global options, spellcheck.
{
  config,
  pkgs,
  lib,
  ...
}: {
  config.vim = {
    viAlias = true;
    vimAlias = true;
    hideSearchHighlight = true;

    clipboard = {
      registers = "unnamedplus";
      providers.wl-copy.enable = true;
    };

    options.shiftwidth = 2;
    globals.mapleader = " ";

    spellcheck.enable = true;

    debugMode = {
      enable = false;
      level = 16;
      logFile = "/tmp/nvim.log";
    };
  };
}
