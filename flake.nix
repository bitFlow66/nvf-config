{
  description = "Neovim configuration (Dendritic Pattern via nvf)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nvf.url = "github:notashelf/nvf";
  };

  outputs = { nixpkgs, nvf, ... }: let
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
    featureLib = import ./features/lib.nix { inherit lib; };
    featureModules = featureLib.mkModules { };

    # Standalone evaluation — used by packages.default
    eval = nvf.lib.neovimConfiguration {
      inherit pkgs;
      modules = featureModules;
    };
  in {
    packages.${system} = {
      default = eval.neovim;
    };

    # NixOS module — import in nixos-config via:
    #   imports = [ inputs.nvf-config.nixosModules.default ];
    # Override per-host with:
    #   programs.nvf.settings.vim.languages.rust.enable = true;
    nixosModules.default = { pkgs, lib, ... }: {
      imports = [ nvf.nixosModules.default ];
      programs.nvf = {
        enable = true;
        settings.vim = (nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = featureModules;
        }).config.vim;
      };
    };

    # Home-Manager module — same pattern as the NixOS module
    homeManagerModules.default = { pkgs, lib, ... }: {
      imports = [ nvf.homeManagerModules.default ];
      programs.nvf = {
        enable = true;
        settings.vim = (nvf.lib.neovimConfiguration {
          inherit pkgs;
          modules = featureModules;
        }).config.vim;
      };
    };
  };
}
