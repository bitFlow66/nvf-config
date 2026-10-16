{
  description = "Neovim configuration (Dendritic Pattern via nvf)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = {
    nixpkgs,
    nvf,
    ...
  }: let
    lib = nixpkgs.lib;
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};

    # -----------------------------------------------------------------
    # Dendritic feature aggregation
    #
    # Features are discovered under ./features; each profile explicitly selects
    # reusable capabilities. VS Code-specific overrides stay in its profile.
    # -----------------------------------------------------------------
    featureLib = import ./features/lib.nix {inherit lib;};
    profileModules = {
      full = featureLib.mkModules {
        include = [
          "assistant.nix"
          "autocmds.nix"
          "autopairs.nix"
          "binds.nix"
          "comments.nix"
          "completion.nix"
          "core.nix"
          "filetree.nix"
          "gestures.nix"
          "git.nix"
          "keymaps.nix"
          "languages.nix"
          "lsp.nix"
          "notes.nix"
          "projects.nix"
          "session.nix"
          "surround.nix"
          "telescope.nix"
          "terminal.nix"
          "treesitter.nix"
          "treesitter-context.nix"
          "ui.nix"
          "utility.nix"
          "window-keymaps.nix"
        ];
      };
      vsCodeSlim =
        (featureLib.mkModules {
          include = [
            "autocmds.nix"
            "binds.nix"
            "comments.nix"
            "core.nix"
            "keymaps.nix"
            "surround.nix"
            "treesitter.nix"
          ];
        })
        ++ [./profiles/vsCodeSlim.nix];
    };

    # Standalone evaluation — used by packages.default.
    fullEval = nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = profileModules.full;
    };

    # Explicit allowlist keeps standalone UI and language tooling out of VS Code.
    vsCodeSlimEval = nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = profileModules.vsCodeSlim;
    };
    editingTest = pkgs.writeText "nvf-editing-test.lua" ''
      local ok, err = pcall(function()
        assert(vim.v.errmsg == "", vim.v.errmsg)
        assert(vim.g.mapleader == " ")
        assert(vim.fn.maparg(">", "x") ~= "")
        for _, key in ipairs({"af", "if", "ac", "ic"}) do
          for _, mode in ipairs({"x", "o"}) do
            assert(vim.fn.maparg(key, mode) ~= "", key .. " missing in " .. mode)
          end
        end
        assert(require("nvim-treesitter-textobjects.config").select.lookahead)
        vim.bo.filetype = "cs"
        vim.api.nvim_buf_set_lines(0, 0, -1, false, {
          "class Greeter", "{", "    public string Greet(string name)",
          "    {", "        return name;", "    }", "}", "", "class Other {}",
        })
        for _, test in ipairs({{"af", 3, 6}, {"if", 5, 5}, {"ac", 1, 7}, {"ic", 3, 6}}) do
          vim.cmd.normal({vim.api.nvim_replace_termcodes("<Esc>", true, false, true), bang = true})
          vim.api.nvim_win_set_cursor(0, {5, 15})
          vim.cmd.normal("v" .. test[1])
          assert(vim.fn.line("v") == test[2] and vim.fn.line(".") == test[3], "wrong selection: " .. test[1])
        end
        vim.cmd.normal({vim.api.nvim_replace_termcodes("<Esc>", true, false, true), bang = true})
        vim.api.nvim_win_set_cursor(0, {5, 15})
        vim.cmd.normal('"ayaf')
        assert(vim.fn.getreg("a"):find("public string Greet", 1, true))
        assert(not vim.fn.getreg("a"):find("class Other", 1, true))
        vim.api.nvim_win_set_cursor(0, {1, 0})
        vim.cmd.normal("vaf")
        assert(vim.fn.line("v") == 3 and vim.fn.line(".") == 6, "lookahead failed")
        vim.cmd.normal({vim.api.nvim_replace_termcodes("<Esc>", true, false, true), bang = true})
        vim.bo.filetype = "python"
        vim.api.nvim_buf_set_lines(0, 0, -1, false, {"value = 1"})
        vim.api.nvim_win_set_cursor(0, {1, 0})
        vim.cmd.normal("gcc")
        assert(vim.api.nvim_get_current_line() == "# value = 1")
        vim.cmd.normal("gcc")
        assert(vim.api.nvim_get_current_line() == "value = 1")
        vim.api.nvim_buf_set_lines(0, 0, -1, false, {"hello"})
        vim.api.nvim_win_set_cursor(0, {1, 0})
        vim.cmd.normal('gziw"')
        assert(vim.api.nvim_get_current_line() == '"hello"')
      end)
      if not ok then
        vim.api.nvim_err_writeln(tostring(err))
        vim.cmd("cquit 1")
      end
    '';
  in {
    packages.${system} = {
      default = fullEval.neovim;
      full = fullEval.neovim;
      vsCodeSlim = vsCodeSlimEval.neovim;
    };

    checks.${system} = {
      vsCodeSlim = assert vsCodeSlimEval.config.vim.viAlias == false;
      assert vsCodeSlimEval.config.vim.vimAlias == false;
      assert vsCodeSlimEval.config.vim.languages.nix.enable == false;
      assert vsCodeSlimEval.config.vim.filetree.neo-tree.enable == false;
      assert vsCodeSlimEval.config.vim.treesitter.textobjects.enable;
      assert vsCodeSlimEval.config.vim.binds.whichKey.enable;
      assert !vsCodeSlimEval.config.vim.binds.cheatsheet.enable;
      assert !vsCodeSlimEval.config.vim.clipboard.providers.wl-copy.enable;
      assert vsCodeSlimEval.config.vim.clipboard.registers == "";
      assert !vsCodeSlimEval.config.vim.treesitter.highlight.enable;
      assert !vsCodeSlimEval.config.vim.treesitter.context.enable;
      assert vsCodeSlimEval.config.vim.utility.surround.enable;
      assert fullEval.config.vim.languages.nix.enable;
      assert fullEval.config.vim.viAlias;
      assert fullEval.config.vim.vimAlias;
      assert fullEval.config.vim.utility.surround.enable;
        pkgs.runCommand "nvf-vsCodeSlim-profile-check" {
          nativeBuildInputs = [vsCodeSlimEval.neovim];
        } ''
          export HOME="$TMPDIR/home"
          mkdir -p "$HOME"
          nvim --headless \
            --cmd 'let g:vscode = 1' \
            -u ${vsCodeSlimEval.neovim.passthru.initLua} \
            -c "lua if vim.g.vscode ~= 1 then vim.cmd('cquit 1') end" \
            -c "lua if vim.g.mapleader ~= ' ' then vim.cmd('cquit 1') end" \
            -c "lua if vim.o.shiftwidth ~= 2 then vim.cmd('cquit 1') end" \
            -c "lua if #vim.fn.maparg('<C-n>', 'n') ~= 0 then vim.cmd('cquit 1') end" \
            -c "lua if #vim.fn.maparg(' e', 'n') == 0 then vim.cmd('cquit 1') end" \
            -c "lua if #vim.fn.maparg('af', 'x') == 0 or #vim.fn.maparg('af', 'o') == 0 then vim.cmd('cquit 1') end" \
            -c "lua if vim.fn.exists(':Neotree') ~= 0 then vim.cmd('cquit 1') end" \
            -c "lua if not pcall(require, 'which-key') then vim.cmd('cquit 1') end" \
            -c "luafile ${editingTest}" \
            -c 'qa!'
          touch "$out"
        '';

      full = assert fullEval.config.vim.binds.whichKey.enable;
      assert fullEval.config.vim.binds.cheatsheet.enable;
      assert fullEval.config.vim.treesitter.context.enable;
      assert fullEval.config.vim.treesitter.highlight.enable;
      assert fullEval.config.vim.clipboard.providers.wl-copy.enable;
        pkgs.runCommand "nvf-full-profile-check" {} ''
          export HOME="$TMPDIR/home"
          mkdir -p "$HOME"
          ${fullEval.neovim}/bin/nvim --headless \
            -u ${fullEval.neovim.passthru.initLua} \
            -c "luafile ${editingTest}" -c 'qa!'
          touch "$out"
        '';
    };

    # NixOS module — import in nixos-config via:
    #   imports = [ inputs.nvf-config.nixosModules.default ];
    # Override per-host with:
    #   programs.nvf.settings.vim.languages.rust.enable = true;
    nixosModules.default = {
      pkgs,
      lib,
      ...
    }: {
      imports = [nvf.nixosModules.default];
      programs.nvf = {
        enable = true;
        settings.vim =
          (nvf.lib.neovimConfiguration {
            inherit pkgs;
            modules = profileModules.full;
          }).config.vim;
      };
    };

    # Home-Manager module — same pattern as the NixOS module
    homeManagerModules.default = {
      pkgs,
      lib,
      ...
    }: {
      imports = [nvf.homeManagerModules.default];
      programs.nvf = {
        enable = true;
        settings.vim =
          (nvf.lib.neovimConfiguration {
            inherit pkgs;
            modules = profileModules.full;
          }).config.vim;
      };
    };
  };
}
