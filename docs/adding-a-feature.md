# Adding a New Feature Module

A **feature** is a single-concern Nix module that owns a slice of `config.vim.*`.
Features are auto-discovered — just create a `.nix` file in `features/` and
`git add` it. No registration needed.

## 1. Create the feature file

Add a `.nix` file under `features/`. The filename becomes the feature's identity
(minus the `.nix` suffix). It is auto-discovered on the next evaluation.

Minimal shape:

```nix
# Feature: my-thing
# One-line description of what this feature configures.
{ config, pkgs, lib, ... }: {
  config.vim = {
    # Your nvf options here
  };
}
```

## 2. Available module arguments

Each feature receives the standard Nix module arguments plus flake context:

| Argument   | Source                     | Purpose                                |
|------------|----------------------------|----------------------------------------|
| `config`   | Full evaluated config      | Read options from other features       |
| `pkgs`     | nixpkgs (with overlays)    | Packages                               |
| `lib`      | nixpkgs.lib                | Module helpers (`mkIf`, `mkEnableOption`, `mkMerge`, `generators.mkLuaInline`) |
| `inputs`   | All flake inputs           | Reference nvf, nixpkgs, etc.           |
| `outputs`  | `self.outputs`             | Reference other features/modules       |

## 3. Common patterns

### Simple toggle feature

```nix
# Feature: my-plugin
{ config, pkgs, lib, ... }: {
  config.vim.myPlugin.enable = true;
}
```

### Feature with inline Lua

Use `lib.generators.mkLuaInline` (not `inputs.nixpkgs.lib.generators.mkLuaInline`):

```nix
# Feature: my-autocmd
{ config, pkgs, lib, ... }: {
  config.vim.autocmds = [
    {
      enable = true;
      desc = "Do something on save";
      event = ["BufWritePost"];
      pattern = ["*.nix"];
      callback = lib.generators.mkLuaInline ''
        function()
          print("saved a nix file!")
        end
      '';
    }
  ];
}
```

### Feature with `lib.mkIf` conditions

```nix
# Feature: conditional-thing
{ config, pkgs, lib, ... }: let
  cfg = config.myOption;
in {
  options.myOption.enable = lib.mkEnableOption "my option";

  config = lib.mkIf cfg.enable {
    config.vim.someOption = true;
  };
}
```

Note: when using `options`, all config must be under a `config = { };` block.
Top-level `config.vim = {}` alongside `options` will fail.

### Feature referencing other features' state

```nix
# Feature: my-integration
{ config, pkgs, lib, ... }: {
  config.vim = lib.mkIf config.vim.telescope.enable {
    # extra telescope config
  };
}
```

## 4. Disabling a feature

Set `enable = false;` with a comment explaining why:

```nix
{ config, pkgs, lib, ... }: {
  config.vim.minimap.codewindow.enable = false; # waiting for upstream PR #86
}
```

## 5. Testing

Run the standard validation:

```bash
nix build .#default        # build the Neovim package
nix flake check            # full flake evaluation check
```

Both will catch type errors and missing options at evaluation time.

## 6. Consuming from nixos-config

The flake exposes NixOS and Home-Manager modules for integration:

```nix
# In your nixos-config flake.nix inputs:
nvf-config = {
  url = "github:bitFlow66/nvf-config";
  inputs.nixpkgs.follows = "nixpkgs-unstable";
};

# In a host or feature:
{ inputs, ... }: {
  imports = [ inputs.nvf-config.nixosModules.default ];
  # All vim config is already included.
  # Override per-host:
  programs.nvf.settings.vim.languages.rust.enable = true;
}
```
