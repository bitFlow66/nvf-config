# Feature: autocmds
# Global autocommands — currently just highlight-on-yank.
{ config, pkgs, lib, ... }: {
  config.vim.autocmds = [
    {
      enable = true;
      desc = "Highlight yanks on copy";
      pattern = ["*"];
      event = ["TextYankPost"];
      callback = lib.generators.mkLuaInline ''
        function()
          vim.highlight.on_yank({ timeout = 200 })
        end
      '';
    }
  ];
}
