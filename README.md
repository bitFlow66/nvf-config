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
  completion, debugging, clipboard integration, and editor UI to VS Code.
- The `vsCodeSlim` package exposes its generated init file as
  `passthru.initLua`. Configure the extension's Linux executable path to
  `${package}/bin/nvim` and its `neovimInitVimPaths.linux` setting to that file.
- In Remote WSL, run the extension in the workspace extension host and install
  the VS Code WSL extension on the Windows client. Do not enable the extension's
  `useWSL` option when Neovim itself runs in the NixOS workspace host.

Both profiles explicitly select reusable modules from `features/` in `flake.nix`.
Core defaults, visual indentation mappings, comments, surround, parsers,
textobjects, and binding helpers have one shared implementation. Only
`profiles/vsCodeSlim.nix` owns VS Code-specific overrides and integration mappings.
It disables standalone aliases, the Wayland clipboard provider, Treesitter
highlighting/indentation, and cheatsheet UI. Standalone window navigation,
Treesitter context, and language tooling are separate features selected only by
`full`.

Which-key is included in both profiles; its popup usability in VSCode Neovim
requires interactive verification and is not established by headless loading.

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
| **keymaps** | shared visual indentation bindings |
| **window-keymaps** | standalone filetree and window navigation bindings |
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
