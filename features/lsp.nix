# Feature: lsp
# LSP infrastructure: format-on-save, lspkind, lightbulb, trouble, signature,
# docs-view, and DAP debugger.
{ config, pkgs, lib, ... }: {
  config.vim = {
    lsp = {
      enable = true;
      formatOnSave = true;
      lspkind.enable = true;
      lightbulb.enable = true;
      trouble.enable = true;
      lspSignature.enable = true;
      otter-nvim.enable = true;
      nvim-docs-view.enable = true;

      lspsaga.enable = false;
    };

    debugger.nvim-dap = {
      enable = true;
      ui.enable = true;
    };
  };
}
