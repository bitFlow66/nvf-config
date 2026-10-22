# nvf Neovim configuration

## Test configuration

`nix run github:bitFlow66/nvf-config#default`

`nix run .`

## Package profiles

- `packages.x86_64-linux.full` (also `default`) is the full standalone configuration with its
  existing language tooling, Neovim UI, aliases, and clipboard provider.
- `packages.x86_64-linux.vsCodeSlim` is the VS Code profile for the
  VSCode Neovim extension. It provides shared editing defaults, comments,
  surround, and Treesitter text objects while leaving language services,
  completion, and debugging to VS Code. Clipboard yanks use VSCode Neovim's
  bridge to the VS Code clipboard; the standalone Wayland provider is disabled.
- The `vsCodeSlim` package exposes its generated init file as
  `passthru.initLua`. Configure the extension's Linux executable path to
  `${package}/bin/nvim` and its `neovimInitVimPaths.linux` setting to that file.
- In Remote WSL, run the extension in the workspace extension host and install
  the VS Code WSL extension on the Windows client. Do not enable the extension's
  `useWSL` option when Neovim itself runs in the NixOS workspace host.

Both profiles explicitly select reusable modules from `features/` in `flake.nix`.
Core defaults, task-oriented Dvorak-friendly mappings, comments, surround, parsers,
textobjects, and binding helpers have one shared implementation.
`features/keymaps.nix` dispatches task actions using the explicit `vscode` module
argument; `profiles/vsCodeSlim.nix` owns VS Code-specific option overrides.
It disables standalone aliases and the Wayland clipboard provider, enables the
VS Code clipboard register bridge, and disables Treesitter highlighting/indentation
and cheatsheet UI. Treesitter context and language tooling are separate features
selected only by `full`; window navigation uses native Vim/VSCode Neovim controls.

The shared task bindings and profile differences are documented in
[`docs/keybindings.md`](docs/keybindings.md). Which-key is included in both
profiles. In `vsCodeSlim`, `Space k` opens a searchable native VS Code Quick Pick
generated from the active, described Neovim mappings; it includes direct keys as
well as leader bindings and does not require a separate Which Key extension. The
binding guide describes the available shortcuts and returning editor focus.

Validate both compositions and their generated-init startup paths with:

```bash
nix build .#vsCodeSlim
nix build .#checks.x86_64-linux.vsCodeSlim .#checks.x86_64-linux.full
```

## Installed languages

- **Nix** — LSP, format, treesitter
- **Markdown** — LSP, format, treesitter
- **Bash** — LSP, format, treesitter
- **C/C++ (clang)** — LSP, format, treesitter
- **Lua** — LSP, format, treesitter
- **Zig** — LSP, format, treesitter
- **Python** — LSP, format, treesitter
- **Rust** — LSP, format, treesitter, crates-nvim
- **C#** — LSP, format, treesitter

## Installed features

| Feature | What's enabled |
|---|---|
| **assistant** | copilot, codecompanion |
| **autocmds** | highlight-on-yank |
| **autopairs** | nvim-autopairs |
| **binds** | whichKey, cheatsheet |
| **comments** | comment-nvim |
| **completion** | nvim-cmp, blink-cmp, luasnip |
| **core** | vi/vim alias, wl-clipboard, spellcheck |
| **filetree** | neo-tree |
| **git** | gitsigns |
| **keymaps** | shared Dvorak-friendly task and editing bindings |
| **lsp** | format-on-save, lspkind, trouble, signature, docs-view, DAP debugger |
| **notes** | todo-comments |
| **projects** | project-nvim |
| **telescope** | telescope |
| **terminal** | toggleterm, lazygit |
| **treesitter** | shared parsers and function/class textobjects |
| **treesitter-context** | standalone syntax context UI |
| **ui** | catppuccin, lualine, bufferline, startify, indent-blankline, notify, navbuddy, smartcolumn, borders |
| **utility** | multicursors, flash, sleuth, diffview |
| **surround** | nvim-surround |
| **vsCodeSlim profile** | Shared editing features plus explicit VS Code overrides; VS Code owns language services, completion, clipboard, debugging, and editor UI |
