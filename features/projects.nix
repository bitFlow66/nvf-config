# Feature: projects
# Project management (project-nvim).
{ config, pkgs, lib, ... }: {
  config.vim.projects.project-nvim = {
    enable = true;
    setupOpts.manual_mode = false;
  };
}
