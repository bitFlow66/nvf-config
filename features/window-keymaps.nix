# Feature: window-keymaps
# Neovim-owned file navigation and window movement.
{...}: {
  config.vim.keymaps = [
    {
      key = "<C-n>";
      mode = "n";
      action = ":Neotree toggle<CR>";
    }
    {
      key = "<C-h>";
      mode = "n";
      action = "<C-w>h";
    }
    {
      key = "<C-j>";
      mode = "n";
      action = "<C-w>j";
    }
    {
      key = "<C-k>";
      mode = "n";
      action = "<C-w>k";
    }
    {
      key = "<C-l>";
      mode = "n";
      action = "<C-w>l";
    }
  ];
}
