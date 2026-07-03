# Feature: languages
# Language support: LSP, formatter, treesitter, and extra diagnostics per lang.
{ config, pkgs, lib, ... }: {
  config.vim.languages = {
    enableFormat = true;
    enableTreesitter = true;
    enableExtraDiagnostics = true;

    nix.enable = true;
    markdown.enable = true;
    bash.enable = true;
    clang.enable = true;
    lua.enable = true;
    zig = {
      enable = true;
    };
    python.enable = true;
    rust = {
      enable = true;
      extensions.crates-nvim.enable = true;
    };
    csharp = {
      enable = true;
    };

    nim.enable = false; # LSP broken on Darwin
  };
}
