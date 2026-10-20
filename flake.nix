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
      extraSpecialArgs.vscode = false;
    };

    # Explicit allowlist keeps standalone UI and language tooling out of VS Code.
    vsCodeSlimEval = nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = profileModules.vsCodeSlim;
      extraSpecialArgs.vscode = true;
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
        vim.cmd.normal('ysiw"')
        assert(vim.api.nvim_get_current_line() == '"hello"')
        vim.cmd.normal([[cs"']])
        assert(vim.api.nvim_get_current_line() == "'hello'")
        vim.cmd.normal("ds'")
        assert(vim.api.nvim_get_current_line() == "hello")
        vim.cmd.normal('viwS"')
        assert(vim.api.nvim_get_current_line() == '"hello"')
        vim.api.nvim_buf_set_lines(0, 0, -1, false, {"first", "second", "third"})
        vim.bo.expandtab = true
        vim.bo.shiftwidth = 2
        vim.api.nvim_win_set_cursor(0, {1, 0})
        vim.cmd.normal("Vj>")
        assert(vim.deep_equal(vim.api.nvim_buf_get_lines(0, 0, -1, false), {"  first", "  second", "third"}), "indent mapping moved or split text: " .. vim.inspect(vim.api.nvim_buf_get_lines(0, 0, -1, false)))
        assert(vim.fn.mode() == "V", "indent mapping lost selection")
        vim.cmd.normal("<")
        assert(vim.api.nvim_buf_get_lines(0, 0, -1, false)[1] == "first")
        vim.cmd.normal({vim.api.nvim_replace_termcodes("<Esc>", true, false, true), bang = true})
        local shared_maps = {
          "<leader><leader>", "<leader>e", "<leader>sg", "<leader>ss",
          "<leader>bb", "<leader>bd", "<leader>bn", "<leader>bp",
          "gd", "gD", "gy", "grr", "gri", "K", "<leader>ca",
          "<leader>cr", "<leader>cf", "<leader>xn", "<leader>xp",
          "<leader>xx", "<leader>gd", "<leader>gn", "<leader>gp",
          "<leader>gv", "<leader>dc", "<leader>di", "<leader>do",
          "<leader>dO", "<leader>tt", "<leader>tw", "<leader>tf",
        }
        for _, key in ipairs(shared_maps) do
          local lhs = key:gsub("<leader>", " ")
          assert(vim.fn.maparg(lhs, "n") ~= "", "missing shared mapping: " .. key)
        end
        for _, key in ipairs({"ys", "yss", "ds", "cs"}) do
          assert(vim.fn.maparg(key, "n") ~= "", "missing surround mapping: " .. key)
        end
        if vim.g.vscode then
          assert(vim.fn.maparg(" e", "n") ~= "", "missing VS Code Explorer mapping")
          assert(vim.fn.maparg("  ", "n") ~= "", "missing VS Code file search mapping")
          assert(vim.fn.maparg("gd", "n") ~= "", "missing VS Code definition mapping")
          assert(vim.fn.maparg("grr", "n") ~= "", "missing VS Code references mapping")
          assert(vim.fn.maparg(" aa", "n") == "", "standalone assistant leaked into VS Code profile")
          assert(vim.fn.maparg(" sj", "n") == "", "standalone Flash leaked into VS Code profile")
          assert(vim.fn.maparg(" ts", "n") == "", "Neovim spell toggle leaked into VS Code")
          assert(vim.fn.maparg(" gl", "n") == "", "unsupported line blame shortcut in VS Code")
          local calls = {}
          package.loaded.vscode = {
            action = function(name, opts) calls[#calls + 1] = {name, opts} end,
            eval_async = function(code) calls[#calls + 1] = {"eval", code} end,
          }
          for key, command in pairs({
            ["gd"] = "editor.action.revealDefinition",
            ["gD"] = "editor.action.revealDeclaration",
            [" gd"] = "git.openChange",
            [" gh"] = "timeline.focus",
            [" gH"] = "workbench.scm.history.focus",
            [" gs"] = "git.stageSelectedRanges",
            [" gu"] = "git.unstageSelectedRanges",
            [" gr"] = "git.revertSelectedRanges",
            [" tb"] = "git.blame.toggleEditorDecoration",
            [" tw"] = "editor.action.toggleWordWrap",
            [" cf"] = "editor.action.formatDocument",
            [" de"] = "editor.debug.action.showDebugHover",
          }) do
            vim.cmd.normal(key)
            assert(calls[#calls][1] == command, "wrong dispatch for " .. key)
          end
          vim.api.nvim_buf_set_lines(0, 0, -1, false, {"needle"})
          vim.api.nvim_win_set_cursor(0, {1, 0})
          vim.cmd.normal(" sw")
          assert(calls[#calls][2].args.query == "needle", "word search missing query")
          vim.cmd.normal(" st")
          assert(calls[#calls][2].args.isRegex, "TODO search missing regex")
          vim.cmd.normal("viw cf")
          assert(calls[#calls][1] == "editor.action.formatSelection", "visual format dispatched document action")
          vim.cmd.normal({vim.api.nvim_replace_termcodes("<Esc>", true, false, true), bang = true})
          vim.cmd.normal(" tf")
          assert(calls[#calls][1] == "eval" and calls[#calls][2]:find("formatOnSave", 1, true))
        else
          for _, key in ipairs({"h", "j", "k", "l", "H", "M", "L", "s", "S"}) do
            assert(vim.fn.maparg(key, "n") == "", "native normal-mode key overwritten: " .. key)
          end
          assert(vim.fn.maparg(" sj", "n") ~= "", "missing lazy Flash shortcut")
          local formatsave = vim.g.formatsave
          vim.cmd.normal(" tf")
          assert(vim.g.formatsave == not formatsave, "format-on-save toggle failed")
          vim.cmd.normal(" tf")
          vim.cmd("enew!")
          local closing = vim.api.nvim_get_current_buf()
          vim.cmd.normal(" bd")
          assert(not vim.bo[closing].buflisted, "close-buffer mapping failed")
          require("codecompanion")
          local range
          vim.api.nvim_create_user_command("CodeCompanionChat", function(opts) range = opts end, {range = true, nargs = "*", force = true})
          vim.api.nvim_buf_set_lines(0, 0, -1, false, {"first", "second", "third"})
          vim.api.nvim_win_set_cursor(0, {1, 0})
          vim.cmd.normal("Vj as")
          assert(range.args == "Add" and range.line1 == 1 and range.line2 == 2, "assistant lost selected lines")
        end
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
      assert vsCodeSlimEval.config.vim.clipboard.enable;
      assert vsCodeSlimEval.config.vim.clipboard.registers == "unnamedplus";
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
            -c "lua if not vim.g.vscode or vim.g.mapleader ~= ' ' or vim.o.shiftwidth ~= 2 or not vim.o.clipboard:find('unnamedplus', 1, true) or #vim.fn.maparg('<C-n>', 'n') ~= 0 or vim.fn.exists(':Neotree') ~= 0 or not pcall(require, 'which-key') then vim.cmd('cquit 1') end" \
            -c "lua if #vim.fn.maparg('af', 'x') == 0 or #vim.fn.maparg('af', 'o') == 0 then vim.cmd('cquit 1') end" \
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
            extraSpecialArgs.vscode = false;
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
            extraSpecialArgs.vscode = false;
          }).config.vim;
      };
    };
  };
}
