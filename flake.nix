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

    # Features are discovered under ./features; each profile selects reusable modules.
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

    fullEval = nvf.lib.neovimConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = profileModules.full;
      extraSpecialArgs.vscode = false;
    };
    vsCodeSlimEval = nvf.lib.neovimConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      modules = profileModules.vsCodeSlim;
      extraSpecialArgs.vscode = true;
    };
  in {
    packages.${system} = {
      default = fullEval.neovim;
      full = fullEval.neovim;
      vsCodeSlim = vsCodeSlimEval.neovim;
    };

    # NixOS module: imports = [ inputs.nvf-config.nixosModules.default ];
    nixosModules.default = {pkgs, ...}: {
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

    # Home-Manager module: same profile as the NixOS module.
    homeManagerModules.default = {pkgs, ...}: {
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
