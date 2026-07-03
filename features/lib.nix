# Dendritic feature aggregation for nvf.
#
# Every .nix file under ./features (except lib.nix) is auto-discovered and
# returned as a list of module paths. Each path is a standard Nix module
# that contributes to config.vim.* — no registration needed, just create the
# file and git add it.
#
# Usage in flake.nix:
#   featureLib = import ./features/lib.nix { inherit lib; };
#   featureModules = featureLib.mkModules { };
#   nvf.lib.neovimConfiguration { modules = featureModules; ... };
{ lib }: let
  inherit (lib) filterAttrs hasSuffix;
in {
  mkModules = { }: let
    entries = builtins.readDir ./.;
    files = filterAttrs (name: type:
      type == "regular" && hasSuffix ".nix" name && name != "lib.nix"
    ) entries;
    sortedNames = builtins.sort builtins.lessThan (builtins.attrNames files);
  in map
    (name: ./. + "/${name}")
    sortedNames;
}
