# Dendritic feature aggregation for nvf.
#
# Every .nix file under ./features (except lib.nix) is discovered. Profiles
# provide explicit include lists; unknown feature names fail evaluation.
#
# Usage in flake.nix:
#   featureLib = import ./features/lib.nix { inherit lib; };
#   fullModules = featureLib.mkModules { include = [ "core.nix" ]; };
#   nvf.lib.neovimConfiguration { modules = fullModules; ... };
{lib}: let
  inherit (lib) filterAttrs hasSuffix;
in {
  mkModules = {include ? null}: let
    entries = builtins.readDir ./.;
    files =
      filterAttrs (
        name: type:
          type
          == "regular"
          && hasSuffix ".nix" name
          && name != "lib.nix"
          && (include == null || builtins.elem name include)
      )
      entries;
    sortedNames = builtins.sort builtins.lessThan (builtins.attrNames files);
    unknown =
      if include == null
      then []
      else builtins.filter (name: !(builtins.hasAttr name files)) include;
  in
    assert lib.assertMsg (unknown == []) "Unknown NVF features: ${builtins.concatStringsSep ", " unknown}";
      map
      (name: ./. + "/${name}")
      sortedNames;
}
