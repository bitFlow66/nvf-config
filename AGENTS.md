# AGENTS.md — nvf-config

## Build / Lint / Test Commands

```bash
# Build the Neovim configuration (no install)
nix build .#default

# Build the slim profile for vscode-neovim
nix build .#vscode

# Exercise the slim profile's generated-init startup contract
nix build .#checks.x86_64-linux.vscode

# Run the configured Neovim (build + execute)
nix run .

# Update the flake lockfile
nix flake update

# Check flake evaluation (catches Nix syntax errors)
nix flake check
```

This repo has **no test framework, no linter, no typechecker**. Validation uses `nix flake check`, package builds, and the focused VS Code profile check.

## Repository Structure

```
├── flake.nix              # entry point — inputs, feature aggregation, outputs
├── features/
│   ├── lib.nix            # auto-discovery engine (builtins.readDir)
│   ├── core.nix           # viAlias, clipboard, options, spellcheck
│   ├── keymaps.nix        # vim.keymaps
│   ├── autocmds.nix       # vim.autocmds
│   ├── ui.nix             # theme, statusline, visuals, dashboard, tabline
│   ├── languages.nix      # vim.languages.*
│   ├── lsp.nix            # vim.lsp.*, debugger
│   ├── completion.nix     # autocomplete, snippets
│   ├── treesitter.nix     # context, textobjects
│   ├── telescope.nix
│   ├── git.nix            # gitsigns
│   ├── filetree.nix       # neo-tree
│   ├── assistant.nix      # copilot, codecompanion
│   ├── utility.nix        # surround, multicursors, flash, sleuth
│   ├── notes.nix          # todo-comments
│   ├── terminal.nix       # toggleterm, lazygit
│   ├── binds.nix          # whichKey, cheatsheet
│   ├── projects.nix       # project-nvim
│   ├── autopairs.nix
│   ├── comments.nix
│   ├── gestures.nix       # gesture-nvim (disabled)
│   └── session.nix        # nvim-session-manager (disabled)
├── profiles/
│   └── vscode/             # explicit slim-profile modules, not auto-discovered
├── docs/
│   └── adding-a-feature.md
├── AGENTS.md
└── flake.lock
```

## Architecture

**Dendritic Pattern** adapted for nvf. Features are auto-discovered `.nix` files
in `features/`. Each feature contributes to `config.vim.*` and is composed via
neovimConfiguration. No registration needed — create a file and `git add` it.

- **`features/lib.nix`** — Auto-discovery engine. `builtins.readDir` finds all
  `.nix` files (excluding `lib.nix`), imports and instantiates each with
  `{ inputs, outputs, lib }`.
- **Feature files** — Standard Nix modules: `{ config, pkgs, lib, ... }: { config.vim = { ... }; }`.
- **`flake.nix`** — Aggregates features via `lib.nix`, builds Neovim via
  `nvf.lib.neovimConfiguration`. Exposes `packages.default` and `nixosModules.default`.

## Code Style Guidelines

### Nix Language

- **Formatting:** Use `nixfmt` or `alejandra`. Indent with 2 spaces.
- **Braces:** Opening brace on the same line as the attribute. Closing brace on its own line.
- **Semicolons:** Required after every attribute definition.
- **Trailing commas:** Do NOT use trailing commas in attribute sets.
- **Strings:** Double-quoted for simple values (`"value"`). Use `''` multiline for longer blocks.
- **No `with` statements.** Use explicit destructuring.

### Feature Module Conventions

- Each feature file owns **one concern**. The filename describes the concern.
- Header comment format: `# Feature: <name>` followed by a one-line description.
- Enable features with `enable = true;`. Disable with `enable = false;` + comment reason.
- Prefer `setupOpts` for raw plugin configuration tables (freeform modules).
- Use `lib.generators.mkLuaInline` (not `inputs.nixpkgs.lib.generators.mkLuaInline`).

### Keymap structure

```nix
{
  key = "<C-n>";
  mode = "n";
  silent = true;
  action = ":Neotree toggle<CR>";
}
```

### Autocommand structure

```nix
{
  enable = true;
  desc = "...";
  pattern = ["*"];
  event = ["TextYankPost"];
  callback = lib.generators.mkLuaInline ''...'';
}
```

### Naming Conventions

- **Feature files:** `kebab-case.nix` (e.g. `filetree.nix`, `treesitter.nix`).
- **Nix attributes:** `camelCase` (e.g. `enableFormat`, `hideSearchHighlight`, `nvim-cmp`).
- **Keymap actions:** `snake_case` for vim commands (`:Neotree toggle`).
- **Header descriptions:** Sentence case, no trailing period.

### Lua Inline Code Inside Nix

- Use `lib.generators.mkLuaInline ''...''`.
- 2-space indentation, `snake_case` for variables/functions, no semicolons.

### Error Handling

- nvf modules validate options at build time; type mismatches produce evaluation errors.
- If a plugin option is missing, check the nvf manual or source.
- Wrap Lua `callback` in `pcall` if calling experimental API functions.

### Importing from nixos-config

```nix
# flake.nix inputs
nvf-config = {
  url = "github:bitFlow66/nvf-config";
  inputs.nixpkgs.follows = "nixpkgs-unstable";
};

# host or feature module
{ inputs, ... }: {
  imports = [ inputs.nvf-config.nixosModules.default ];
  # per-host override example:
  programs.nvf.settings.vim.languages.rust.enable = true;
}
```

### Git Conventions

- Commit messages are short, lowercase, imperative mood: `split into features`, `added nixosModule export`.
- No conventional commits / no scope prefixes.
- `flake.lock` is committed; update via `nix flake update`.

### Disabled Features Pattern

Annotate every `enable = false;` with a short reason comment:
```nix
session.nvim-session-manager.enable = false; # autoload is intrusive
```

### Deleting a Feature

1. `rm features/<name>.nix`
2. If git-tracked: `git rm features/<name>.nix`
3. Verify with `nix flake check` (untracked files invisible to evaluator)
