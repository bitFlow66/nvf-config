{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = {nixpkgs, ...} @ inputs: {
    packages.x86_64-linux = {
      # Set the default package to the wrapped instance of Neovim.
      # This will allow running your Neovim configuration with
      # `nix run` and in addition, sharing your configuration with
      # other users in case your repository is public.
      default =
        (inputs.nvf.lib.neovimConfiguration {
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          modules = [
            {
              config.vim = {
                keymaps = [
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

                  # Move between buffers
                  {
                    key = "<S-l>";
                    mode = ["n" "x"];
                    silent = true;
                    action = ":bn<CR>";
                  }
                  {
                    key = "<S-h>";
                    mode = ["n" "x"];
                    silent = true;
                    action = ":bp<CR>";
                  }
                  # Close buffer
                  {
                    key = "<leader>bx";
                    mode = "n";
                    silent = true;
                    action = ":bd<CR>";
                  }

                  # Visual mode
                  # Move highlighted lines and re-highlight
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

                viAlias = true;
                vimAlias = true;
                debugMode = {
                  enable = false;
                  level = 16;
                  logFile = "/tmp/nvim.log";
                };

                spellcheck = {
                  enable = true;
                };

                lsp = {
                  formatOnSave = true;
                  lspkind.enable = false;
                  lightbulb.enable = true;
                  lspsaga.enable = false;
                  trouble.enable = true;
                  lspSignature.enable = true;
                  otter-nvim.enable = true;
                  lsplines.enable = true;
                  nvim-docs-view.enable = true;
                };

                debugger = {
                  nvim-dap = {
                    enable = true;
                    ui.enable = true;
                  };
                };

                # This section does not include a comprehensive list of available language modules.
                # To list all available language module options, please visit the nvf manual.
                languages = {
                  enableLSP = true;
                  enableFormat = true;
                  enableTreesitter = true;
                  enableExtraDiagnostics = true;

                  # languages
                  nix.enable = true;
                  markdown.enable = true;
                  bash.enable = true;
                  clang.enable = true;
                  lua.enable = true;
                  zig.enable = true;
                  python.enable = true;
                  rust = {
                    enable = true;
                    crates.enable = true;
                  };
                  csharp.enable = false;

                  # Nim LSP is broken on Darwin and therefore
                  # should be disabled by default. Users may still enable
                  # `vim.languages.vim` to enable it, this does not restrict
                  # that.
                  # See: <https://github.com/PMunch/nimlsp/issues/178#issue-2128106096>
                  nim.enable = false;
                };

                visuals = {
                  nvim-scrollbar.enable = true;
                  nvim-web-devicons.enable = true;
                  nvim-cursorline.enable = true;
                  cinnamon-nvim.enable = true;
                  fidget-nvim.enable = true;

                  highlight-undo.enable = true;
                  indent-blankline.enable = true;
                };

                statusline = {
                  lualine = {
                    enable = true;
                    theme = "catppuccin";
                  };
                };

                theme = {
                  enable = true;
                  name = "catppuccin";
                  style = "mocha";
                  transparent = false;
                };

                autopairs.nvim-autopairs.enable = true;

                autocomplete.nvim-cmp.enable = true;
                snippets.luasnip.enable = true;

                filetree = {
                  neo-tree = {
                    enable = true;
                  };
                };

                tabline = {
                  nvimBufferline.enable = true;
                };

                treesitter.context.enable = true;

                binds = {
                  whichKey.enable = true;
                  cheatsheet.enable = true;
                };

                telescope.enable = true;

                git = {
                  enable = true;
                  gitsigns.enable = true;
                  gitsigns.codeActions.enable = false; # throws an annoying debug message
                };

                minimap = {
                  codewindow.enable = true; # lighter, faster, and uses lua for configuration
                };

                dashboard = {
                  dashboard-nvim.enable = false;
                  alpha.enable = true;
                };

                notify = {
                  nvim-notify.enable = true;
                };

                projects = {
                  project-nvim.enable = true;
                };

                utility = {
                  vim-wakatime.enable = false;
                  diffview-nvim.enable = true;
                  yanky-nvim.enable = false;
                  icon-picker.enable = false;
                  surround.enable = true;
                  leetcode-nvim.enable = false;
                  multicursors.enable = true;

                  motion = {
                    hop.enable = true;
                    leap.enable = true;
                    precognition.enable = true;
                  };
                  images = {
                    image-nvim.enable = true;
                  };
                };

                notes = {
                  neorg.enable = false;
                  todo-comments.enable = true;
                };

                terminal = {
                  toggleterm = {
                    enable = true;
                    lazygit.enable = true;
                  };
                };

                ui = {
                  borders.enable = true;
                  noice.enable = false;
                  colorizer.enable = true;
                  modes-nvim.enable = false; # the theme looks terrible with catppuccin
                  illuminate.enable = true;
                  breadcrumbs = {
                    enable = true;
                    navbuddy.enable = true;
                  };
                  smartcolumn = {
                    enable = true;
                    setupOpts.custom_colorcolumn = {
                      # this is a freeform module, it's `buftype = int;` for configuring column position
                      nix = "110";
                      ruby = "120";
                      java = "130";
                      go = ["90" "130"];
                    };
                  };
                  fastaction.enable = true;
                };

                assistant = {
                  chatgpt.enable = false;
                  copilot = {
                    enable = false;
                    cmp.enable = true;
                  };
                };

                session = {
                  nvim-session-manager.enable = false;
                };

                gestures = {
                  gesture-nvim.enable = false;
                };

                comments = {
                  comment-nvim.enable = true;
                };
              };
            }
          ];
        })
        .neovim;
    };
  };
}
