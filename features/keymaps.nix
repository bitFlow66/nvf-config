# Feature: keymaps
# Global keybindings — filetree toggles, window navigation, visual indent.
{ config, pkgs, lib, ... }: {
  config.vim.keymaps = [
    {
      key = "<C-n>";
      mode = "n";
      silent = true;
      action = ":Neotree toggle<CR>";
    }

    # Move between windows with jhlk
    {
      key = "<C-h>";
      mode = "n";
      silent = true;
      action = "<C-w>h";
    }
    {
      key = "<C-j>";
      mode = "n";
      silent = true;
      action = "<C-w>j";
    }
    {
      key = "<C-k>";
      mode = "n";
      silent = true;
      action = "<C-w>k";
    }
    {
      key = "<C-l>";
      mode = "n";
      silent = true;
      action = "<C-w>l";
    }

    # Visual mode — move highlighted lines and re-highlight
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
