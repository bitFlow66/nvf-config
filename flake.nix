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
    # Every .nix file under ./features (except lib.nix) is auto-discovered
    # and composed into a list of modules passed to nvf's evaluator.
    # No registration needed — just create a file and git add it.
    # -----------------------------------------------------------------
    featureLib = import ./features/lib.nix {inherit lib;};
    featureModules = featureLib.mkModules {};

    # Standalone evaluation — used by packages.default.
    fullEval = nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = featureModules;
    };

    # Explicit allowlist keeps standalone UI and language tooling out of VS Code.
    vscodeEval = nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules =
        (featureLib.mkModules {
          include = [
            "autocmds.nix"
            "comments.nix"
            "surround.nix"
          ];
        })
        ++ [
          ./profiles/vscode/core.nix
          ./profiles/vscode/treesitter.nix
          ./profiles/vscode/keymaps.nix
        ];
    };
  in {
    packages.${system} = {
      default = fullEval.neovim;
      vscode = vscodeEval.neovim;
    };

    checks.${system}.vscode = assert vscodeEval.config.vim.viAlias == false;
    assert vscodeEval.config.vim.vimAlias == false;
    assert vscodeEval.config.vim.languages.nix.enable == false;
    assert vscodeEval.config.vim.filetree.neo-tree.enable == false;
    assert vscodeEval.config.vim.treesitter.textobjects.enable;
    assert !vscodeEval.config.vim.treesitter.highlight.enable;
    assert vscodeEval.config.vim.utility.surround.enable;
    assert fullEval.config.vim.languages.nix.enable;
    assert fullEval.config.vim.viAlias;
    assert fullEval.config.vim.vimAlias;
    assert fullEval.config.vim.utility.surround.enable;
      pkgs.runCommand "nvf-vscode-profile-check" {
        nativeBuildInputs = [vscodeEval.neovim];
      } ''
        export HOME="$TMPDIR/home"
        mkdir -p "$HOME"
        nvim --headless \
          --cmd 'let g:vscode = 1' \
          -u ${vscodeEval.neovim.passthru.initLua} \
          -c "lua if vim.g.vscode ~= 1 then vim.cmd('cquit 1') end" \
          -c "lua if vim.g.mapleader ~= ' ' then vim.cmd('cquit 1') end" \
          -c "lua if vim.o.shiftwidth ~= 2 then vim.cmd('cquit 1') end" \
          -c "lua if #vim.fn.maparg('<C-n>', 'n') ~= 0 then vim.cmd('cquit 1') end" \
          -c "lua if #vim.fn.maparg(' e', 'n') == 0 then vim.cmd('cquit 1') end" \
          -c "lua if vim.fn.exists(':Neotree') ~= 0 then vim.cmd('cquit 1') end" \
          -c 'qa'
        touch "$out"
      '';

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
            modules = featureModules;
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
            modules = featureModules;
          }).config.vim;
      };
    };
  };
}
