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

                options.shiftwidth = 2;

                spellcheck = {
                  enable = true;
                };

                lsp = {
                  formatOnSave = true;
                  lspkind.enable = true;
                  lightbulb.enable = true;
                  lspsaga.enable = false; # Look into this!!
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
                  zig = {
                    enable = true;
                    lsp.package = ["zls"];
                  };
                  python.enable = true;
                  rust = {
                    enable = true;
                    crates.enable = true;
                  };
                  csharp.enable = true;

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

                autocomplete = {
                  nvim-cmp = {
                    enable = true;
                    sourcePlugins = [
                      "codecompanion-nvim"
                    ];
                  };
                  blink-cmp.friendly-snippets.enable = true;
                };
                snippets.luasnip.enable = true;

                filetree = {
                  neo-tree = {
                    enable = true;
                  };
                };

                tabline = {
                  nvimBufferline = {
                    enable = true;
                    setupOpts.options.numbers = "none";
                    mappings = {
                      cycleNext = "<S-l>";
                      cyclePrevious = "<S-h>";
                      closeCurrent = "<leader>bx";
                    };
                  };
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
                  multicursors.enable = true;

                  motion = {
                    leap.enable = false;
                    flash-nvim.enable = true;
                    precognition.enable = false;
                  };
                  images = {
                    image-nvim.enable = false; # Does not work for wsl, because 'ueberzug' is missing
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
                    enable = true;
                    cmp.enable = true;
                  };
                  codecompanion-nvim = {
                    enable = true;
                    setupOpts = {
                      opts = {
                        send_code = true;
                      };
                      display.chat.auto_scroll = true;
                      strategies = {
                        inline.adapter = "ollama";
                        chat.adapter = "ollama";
                        cmd.adpater = "ollama";
                      };
                    };
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
