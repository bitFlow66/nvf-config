# Feature: session
# Session management (nvim-session-manager) — disabled; autoload is intrusive.
{ config, pkgs, lib, ... }: {
  config.vim.session.nvim-session-manager = {
    enable = false;
    setupOpts = {
      autoload_mode = "Disabled";
      sessions_dir = "~/.vim/session";
    };
  };
}
