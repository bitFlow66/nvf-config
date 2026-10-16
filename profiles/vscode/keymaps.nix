# VS Code profile: editing mappings that do not depend on Neovim-owned windows.
{
  config,
  pkgs,
  lib,
  ...
}: {
  config.vim.keymaps = [
    {
      key = "<leader>e";
      mode = "n";
      silent = true;
      action = "<cmd>lua if vim.g.vscode then require('vscode').action('workbench.action.quickOpen') end<CR>";
    }
    {
      key = ">";
      mode = "v";
      silent = true;
      action = "><CR>gv";
    }
    {
      key = "<";
      mode = "v";
      silent = true;
      action = "<<CR>gv";
    }
  ];
}
