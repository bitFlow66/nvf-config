# Profile: vsCodeSlim
# Explicit VS Code overrides; reusable behavior stays in features/.
{lib, ...}: {
  config.vim = {
    viAlias = lib.mkForce false;
    vimAlias = lib.mkForce false;
    clipboard = {
      # vscode-neovim supplies the +/* bridge to VS Code's clipboard.
      enable = lib.mkForce true;
      registers = lib.mkForce "unnamedplus";
      providers.wl-copy.enable = lib.mkForce false;
    };
    treesitter = {
      highlight.enable = lib.mkForce false;
      indent.enable = lib.mkForce false;
    };
    binds.cheatsheet.enable = lib.mkForce false;
    keymaps = [
      {
        key = "<leader>e";
        mode = "n";
        desc = "Quick Open";
        action = "<cmd>lua require('vscode').action('workbench.action.quickOpen')<CR>";
      }
    ];
  };
}
