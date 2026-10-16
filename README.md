# nvf Neovim configuration

## Test configuration

`nix run github:bitFlow66/nvf-config#default`

`nix run .`

## Package profiles

- `packages.x86_64-linux.default` is the full standalone configuration with its
  existing language tooling, Neovim UI, aliases, and clipboard provider.
- `packages.x86_64-linux.vscode` is a separate slim profile for the
  VSCode Neovim extension. It provides shared editing defaults, comments,
  surround, and Treesitter text objects while leaving language services,
  completion, debugging, clipboard, and editor UI to VS Code.
- The slim package exposes its generated init file as
  `passthru.initLua`. Configure the extension's Linux executable path to
  `${package}/bin/nvim` and its `neovimInitVimPaths.linux` setting to that file.
- In Remote WSL, run the extension in the workspace extension host and install
  the VS Code WSL extension on the Windows client. Do not enable the extension's
  `useWSL` option when Neovim itself runs in the NixOS workspace host.

Validate the slim package and its `-u` startup path with:

```bash
nix build .#vscode
nix build .#checks.x86_64-linux.vscode
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
| **keymaps** | custom bindings (filetree, window nav) |
| **lsp** | format-on-save, lspkind, trouble, signature, docs-view, DAP debugger |
| **notes** | todo-comments |
| **projects** | project-nvim |
| **telescope** | telescope |
| **terminal** | toggleterm, lazygit |
| **treesitter** | context, textobjects |
| **ui** | catppuccin, lualine, bufferline, startify, indent-blankline, notify, navbuddy, smartcolumn, borders |
| **utility** | multicursors, flash, sleuth, diffview |
| **surround** | nvim-surround |
| **VS Code profile** | Slim modal-editing package; VS Code owns language services, completion, clipboard, debugging, and editor UI |
