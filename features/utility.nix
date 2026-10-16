# Feature: utility
# Editor quality-of-life utilities: multicursors, flash, sleuth, diffview,
# motion, images, and disabled alternatives.
{
  config,
  pkgs,
  lib,
  ...
}: {
  config.vim.utility = {
    diffview-nvim.enable = true;
    multicursors.enable = true;
    sleuth.enable = true;

    vim-wakatime.enable = false;
    yanky-nvim.enable = false;
    icon-picker.enable = false;

    motion = {
      flash-nvim.enable = true;
      leap.enable = false; # prefer flash.nvim
      precognition.enable = false;
    };

    images.image-nvim.enable = false; # does not work for wsl, ueberzug missing
  };
}
