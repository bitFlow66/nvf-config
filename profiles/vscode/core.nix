# VS Code profile: minimal editor defaults without standalone aliases or clipboard providers.
{
  config,
  pkgs,
  lib,
  ...
}: {
  config.vim = {
    viAlias = lib.mkForce false;
    vimAlias = lib.mkForce false;
    hideSearchHighlight = true;
    options.shiftwidth = 2;
    spellcheck.enable = true;
    globals.mapleader = " ";
  };
}
