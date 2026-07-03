# Feature: notes
# Note-taking and annotation plugins.
{ config, pkgs, lib, ... }: {
  config.vim.notes = {
    todo-comments.enable = true;
    neorg.enable = false;
  };
}
