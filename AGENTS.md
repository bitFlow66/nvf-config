# AGENTS.md — nvf-config

## Build / Lint / Test Commands

```bash
# Build the Neovim configuration (no install)
nix build .#default

# Run the configured Neovim (build + execute)
nix run .

# Update the flake lockfile
nix flake update

# Check flake evaluation (catches Nix syntax errors)
nix flake check

# Rebuild and switch system config if part of a larger NixOS config
# (not typically used here since this is standalone nvf)
sudo nixos-rebuild switch --flake .
```

This repo has **no test framework, no linter, no typechecker**. The only validation is `nix flake check` and a successful `nix build .#default`. To "run a single test": there are none. If adding a module option test, you would run `nix eval .#default` or `nix build .#default`.

## Repository Structure

- **`flake.nix`** — Single-file Nix flake containing the entire Neovim configuration via [nvf](https://github.com/notashelf/nvf).
- **`flake.lock`** — Pinned inputs (nixpkgs, nvf).
- **`README.md`** — Minimal docs.

All configuration lives inside `inputs.nvf.lib.neovimConfiguration { modules = [ { config.vim = { ... } } ]; }`.

## Code Style Guidelines

### Nix Language

- **Formatting:** Use `nixfmt` or `alejandra` (project is unformatted currently; prefer `alejandra` for new code). Indent with 2 spaces.
- **Braces:** Opening brace on the same line as the attribute. Closing brace on its own line.
- **Semicolons:** Required after every attribute definition.
- **Trailing commas:** Do NOT use trailing commas in attribute sets (Nix does not support them).
- **Strings:** Double-quoted strings for simple values (`"value"`). Use `''` multiline strings for longer blocks or Lua inline code.
- **Paths:** Use `./relative/path` syntax. Access flake inputs via the `inputs` argument.

### nvf Module Conventions

- The top-level attribute path is `config.vim.*`. All plugin/feature toggles live under this.
- Enable features explicitly with `enable = true;` rather than relying on defaults.
- Prefer `setupOpts` for passing raw plugin configuration tables (freeform modules).
- Keymaps follow this structure:
  ```nix
  {
    key = "<C-n>";
    mode = "n";
    silent = true;
    action = ":Neotree toggle<CR>";
  }
  ```
- Autocommands use:
  ```nix
  {
    enable = true;
    desc = "...";
    pattern = ["*"];
    event = ["TextYankPost"];
    callback = inputs.nixpkgs.lib.generators.mkLuaInline ''...'';
  }
  ```
- Languages are enabled under `config.vim.languages.<lang>.enable = true;`.
- Disable features by setting `enable = false;` (never delete the attribute).
- Use comments with `#` for single-line, `/* */` for block comments. Annotate `enable = false;` with a reason comment.

### Lua Inline Code

- Use `inputs.nixpkgs.lib.generators.mkLuaInline ''...''` to embed Lua snippets inside Nix.
- Use the `''` multiline string syntax for Lua blocks.
- Follow standard Lua conventions inside: 2-space indentation, `snake_case` for variables/functions, no semicolons.

### Naming Conventions

- **Nix attributes:** `camelCase` (e.g., `enableFormat`, `hideSearchHighlight`, `nvim-cmp`).
- **Nix variable names:** `camelCase` or `kebab-case` for packages.
- **Keymap actions:** `snake_case` for vim commands (`:Neotree toggle`).
- **Descriptions/comments:** Sentence case, no trailing period in short comments.

### Error Handling

- nvf modules validate options at build time; type mismatches produce evaluation errors.
- If a plugin option is missing, check the nvf manual or source — nvf uses freeform modules that are loosely typed.
- Wrap Lua `callback` in `pcall` if calling experimental API functions.
- Use `builtins.tryEval` only when absolutely necessary (avoid in normal config code).

### Imports / Module Organization

- Currently everything is in `flake.nix`. If splitting into modules:
  ```nix
  {
    imports = [
      ./modules/editor.nix
      ./modules/languages.nix
      ./modules/ui.nix
    ];
  }
  ```
- Keep module files focused on one concern (languages, UI, LSP, etc.).
- Module files export an attribute set with `{ config, pkgs, ... }: { ... }`.

### Git Conventions

- Commit messages are short, lowercase, imperative mood: `update nix flake`, `enabled textobjects`.
- No conventional commits / no scope prefixes.
- `flake.lock` is committed and should be updated via `nix flake update`.

### Disabled Features Pattern

When a feature is explicitly disabled, annotate with a short reason:
```nix
minimap.codewindow.enable = false; # lighter alternative not yet stable
motion.leap.enable = false;        # prefer flash.nvim
```

### Comments

- Prefer `#` for single-line comments in Nix.
- Use `/* */` for multi-line or block-disabling large sections.
- Whenever you `enable = false`, leave a comment explaining why.
- Avoid obvious comments (`# enable lua` above `lua.enable = true;`).
