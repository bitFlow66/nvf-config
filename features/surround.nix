# Feature: surround
# Add, change, and remove surrounding pairs of text.
{
  config,
  pkgs,
  lib,
  ...
}: {
  config.vim.utility.surround.enable = true;
}
