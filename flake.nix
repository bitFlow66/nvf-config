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
                extraPlugins = with inputs.nixpkgs.legacyPackages.x86_64-linux.vimPlugins; {
                  # Path autocompletion
                  "cmp-path" = {
                    package = cmp-path;
                  };
                };

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

                autocmds = [
                  {
                    enable = true;
                    desc = "Highlight yanks on copy";
                    pattern = ["*"];
                    event = ["TextYankPost"];
                    callback = inputs.nixpkgs.lib.generators.mkLuaInline ''
                      function()
                        vim.highlight.on_yank({ timeout = 200 })
                      end
                    '';
                  }
                ];

                viAlias = true;
                vimAlias = true;
                hideSearchHighlight = true;

                clipboard = {
                  registers = ["unnamedplus"];
                  providers.wl-copy.enable = true;
                };

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

                debugger = {
                  nvim-dap = {
                    enable = true;
                    ui.enable = true;
                  };
                };

                # This section does not include a comprehensive list of available language modules.
                # To list all available language module options, please visit the nvf manual.
                languages = {
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
                  csharp = {
                    enable = true;
                    lsp.package = ["csharp-ls"];
                  };

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
                    sources = {
                      nvim-cmp = null;
                      buffer = "[Buffer]";
                      path = "[Path]";
                    };

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

                treesitter = {
                  context.enable = true;
                  textobjects = {
                    enable = true;
                    setupOpts = {
                      select = {
                        enable = true;
                        keymaps = {
                          "af" = {
                            query = "@function.outer";
                            desc = "function";
                          };
                          "if" = {
                            query = "@function.inner";
                            desc = "function";
                          };
                          "ac" = {
                            query = "@class.outer";
                            desc = "class";
                          };
                          "ic" = {
                            query = "@class.inner";
                            desc = "class";
                          };
                        };
                        lookahead = true;
                      };
                    };
                  };
                };

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
                  startify = {
                    enable = true;
                    changeToVCRoot = true;
                  };
                };

                notify = {
                  nvim-notify.enable = true;
                };

                projects = {
                  project-nvim = {
                    enable = true;
                    setupOpts = {
                      manual_mode = false;
                    };
                  };
                };

                utility = {
                  diffview-nvim.enable = true;
                  surround.enable = true;
                  multicursors.enable = true;
                  sleuth.enable = true;

                  vim-wakatime.enable = false;
                  yanky-nvim.enable = false;
                  icon-picker.enable = false;

                  motion = {
                    flash-nvim.enable = true;

                    leap.enable = false;
                    precognition.enable = false;
                  };
                  images = {
                    image-nvim.enable = false; # Does not work for wsl, because 'ueberzug' is missing
                  };
                };

                notes = {
                  todo-comments.enable = true;

                  neorg.enable = false;
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
                  nvim-session-manager = {
                    enable = false;
                    setupOpts = {
                      autoload_mode = "Disabled";
                      sessions_dir = "~/.vim/session";
                    };
                  };
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
