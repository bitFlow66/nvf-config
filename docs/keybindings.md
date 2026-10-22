# Keybindings

The `full` and `vsCodeSlim` profiles share a task-oriented, Dvorak-friendly
binding layer. Mnemonic letters identify actions; navigation does not depend on
QWERTY punctuation positions. The leader is `Space`. Most custom commands use
`Space`, a category, and an action. Native Vim motions, operators, text objects,
`h/j/k/l`, `M`, and `Ctrl+w` window commands retain their normal meanings.
`H` and `L` switch to the previous and next editor; use `gg` and `G` for the
top and bottom of the file.

The shared map lives in `features/keymaps.nix`. Actions dispatch to native
Neovim plugins/LSP in `full` and to VS Code commands through vscode-neovim in
`vsCodeSlim`. A mapping being present in both profiles does not guarantee that
the host offers identical functionality; see the profile notes below.

## Leader Map

| Prefix | Area | Primary bindings |
|---|---|---|
| `Space Space` | Files | Find files |
| `Space e` | Files | Explorer |
| `Space f` | Files | `fr` recent files, `fs` save |
| `Space s` | Search | `sg` project text, `st` TODOs, `sw` word under cursor, `ss` document symbols, `sS` workspace symbols, `sj` Flash jump in `full` |
| `Space b` | Buffers/editors | `bb` list, `bd` close, `bn` next, `bp` previous; `H/L` quick previous/next |
| `Space c` | Code | `ca` action, `cr` rename, `cf` format, `cs` signature help |
| `Space x` | Diagnostics | `xn/xp` next/previous, `xd` hover/details, `xx` workspace, `xb` buffer, `xq` quickfix; VS Code uses Problems for `xx/xb/xq` |
| `Space g` | Git | `gg` overview, `gd` diff, `gn/gp` next/previous change, `gv` preview, `gh/gH` history, `gs/gu/gr` stage/unstage/revert (scope differs below), `gl` line blame in `full` only |
| `Space d` | Debug | `dc` continue (also starts in `full`), `db` breakpoint, `di/do/dO` step into/over/out, `dC` run to cursor, `dr` restart, `dq` stop, `de` inspect expression, `du` UI |
| `Space t` | Toggles | `tf` format-on-save, `tt` terminal, `tw` wrap, `ts` spelling in `full` only, `tb` inline blame |
| `Space a` | Assistant (`full`) | `aa` actions, `ac` chat, visual `as` add selected lines to chat (does not submit a prompt) |
| `Space k` | Help | Shortcut/command help |

`Space e` opens Neo-tree in `full` and the VS Code Explorer in `vsCodeSlim`.
`Space Space` finds files in both. `Space k` opens the cheatsheet in `full` and
a searchable native VS Code Quick Pick in `vsCodeSlim`.
For quick buffer switching, `H` selects the previous editor and `L` selects the
next editor in both profiles. `gg` and `G` retain Vim's file-top and file-bottom
motions. In `vsCodeSlim`, the searchable `Space k` picker includes described
direct mappings such as `gd`, `H`, and `L`.

## Code Navigation

| Keys | Action |
|---|---|
| `gd` | Definition |
| `gD` | Declaration |
| `gy` | Type definition |
| `grr` | References |
| `gri` | Implementations |
| `K` | Hover documentation |

These are normal-mode mappings. `gD` means declaration in both profiles; VS Code
Neovim's visual-mode `gD` remains its built-in peek-definition action.

## Editing Grammar

| Keys | Action |
|---|---|
| `af` / `if` | Around/inside function text object |
| `ac` / `ic` | Around/inside class text object |
| `ys{motion}{pair}` | Surround motion/text object |
| `yss{pair}` | Surround current line |
| `yS{motion}{pair}` / `ySS{pair}` | Surround on separate lines |
| Visual `S{pair}` / `gS{pair}` | Surround selection inline/on separate lines |
| `ds{pair}` | Delete surrounding pair |
| `cs{old}{new}` / `cS{old}{new}` | Change surrounding pair inline/on separate lines |
| `gc` / `gcc` | Comment selection/current line |
| `gb` / `gbc` | Block comment selection/current line where supported |
| Visual `>` / `<` | Indent/outdent and retain selection |

The former `gz` surround family is removed. Insert-mode surround uses upstream
`Ctrl+g s` / `Ctrl+g S` in standalone Neovim. It is not part of the shared contract:
VS Code does not forward `Ctrl+g` to Neovim by default.
Visual `S` belongs to surround; Flash's previous `s/S` mappings are not kept.

For example, `ysiw"` reads as `ys` (add surrounding delimiters), `iw` (the inner
word text object, excluding surrounding whitespace), and `"` (the delimiter to
add). On `hello world`, with the cursor anywhere in `hello`, it produces
`"hello" world`. This is the surround plugin's `ys` operator, not a normal yank.
Substitute another text object or motion, such as `ysaw"` to include the word's
adjacent whitespace, or `yss"` to surround the current line.

## Profile Differences And Limitations

| Area | `full` | `vsCodeSlim` |
|---|---|---|
| File/search | Telescope, Neo-tree, Cheatsheet | VS Code Quick Open, Explorer, Find, Symbols and command palette |
| Language actions | Neovim LSP | VS Code language-service commands |
| Git | Gitsigns, Diffview, Lazygit | Built-in Git, inline changes, Timeline, and Source Control Graph |
| Debug | nvim-dap | VS Code debugger commands |
| Assistant/Flash | Available in `full` | Not mapped; plugins are not part of slim |
| Terminal | ToggleTerm | VS Code integrated terminal |

`Space sw` seeds search with the word under the cursor. VS Code `Space st` seeds
a regex search for TODO/FIXME/HACK/WARN/PERF/NOTE. `Space cf` formats the
document in normal mode and the selection in visual mode, subject to formatter
range support.

`Space fr` uses VS Code's Open Recent picker, which also contains recent folders
and workspaces; standalone Telescope lists recent files only. VS Code Problems
aliases `Space xb/xq` do not apply a current-file filter or open a Neovim quickfix
window. VS Code `Space xd` uses the native hover, which can include diagnostics
and language documentation.

Git scopes are deliberately explicit; VS Code does not emulate Gitsigns:

| Keys | `full` | `vsCodeSlim` |
|---|---|---|
| `Space gg` | Lazygit | Source Control |
| `Space gd` | Repository diff | Active changed file diff (`git.openChange`) |
| `Space gn/gp` | Next/previous hunk | Show next/previous inline change widget |
| `Space gv` | Preview cursor hunk | Show next inline change widget |
| `Space gh` | File Git history | Focus Timeline (unpin it to follow the active file; includes local history) |
| `Space gH` | Repository Git history | Focus Source Control Graph; requires a history provider |
| `Space gs` | Stage entire cursor hunk | Stage changed lines at cursor, not the entire hunk |
| `Space gu` | Undo last staged hunk | Unstage changed lines at cursor in a staged/index diff, not an ordinary working file |
| `Space gr` | Reset cursor hunk | Revert change intersecting cursor; saves the document and discards that change |
| `Space gl` | Show line blame | Not mapped; use `Space tb` for inline blame |

`Space tb` toggles VS Code's built-in Git blame decoration (a persistent user
setting), not SCM focus. `Space tf` toggles standalone format-on-save for the
session; in VS Code it persists a language-specific `editor.formatOnSave` setting
in the workspace, or user settings if no workspace is open. More-specific
folder settings or enforced policy can still take precedence. `Space tw` uses
VS Code's native word-wrap toggle. `Space ts` is standalone-only because stock
VS Code has no spell-check toggle.

In VS Code `Space de` shows debug hover rather than adding a Watch expression,
and `Space du` opens Run and Debug rather than toggling a Neovim layout. Debug
actions require a suitable launch configuration/adapter; stepping and evaluation
require a paused session. `Space dq` requests stop; use VS Code's Disconnect
command when detaching from an attached process is intended. In VS Code start
with F5 or Run > Start Debugging; `Space dc` only continues a paused session.

The shared keymap defines the task-level contract and removes conflicting
Bufferline, standalone window-navigation, Flash, and old surround mappings.
Plugin-local controls and VS Code-native shortcuts remain available unless
listed above. Commenting is provided by Comment.nvim in `full` and VS Code's
comment integration in `vsCodeSlim`.

## VS Code Setup And Shortcut Conflicts

Use the `vsCodeSlim` executable **and** its generated `passthru.initLua`, as
described in the README. After updating the deployed package/paths, run
`Neovim: Restart Extension` or reload the window. Building this flake alone does
not update the extension's configured store paths.

No `keybindings.json` entries are needed for these Space/letter sequences under
the default VSCode Neovim setup. In a focused text editor, normal/visual-mode
typing reaches Neovim, which resolves the mappings and calls VS Code commands
directly. The mappings are not imported into VS Code's Keyboard Shortcuts list.
Insert mode remains VS Code-owned, so typing `Space e` there inserts text.

VS Code still resolves explicit keyboard shortcuts first. User bindings or other
extensions that bind `Space`, a bare letter, or a matching chord while the editor
has focus can intercept these keys. Remove/restrict only such conflicting
bindings (for example with a mode-aware `when` clause). Do not duplicate the
whole leader map in VS Code. Disable VSCodeVim if using VSCode Neovim.

Ctrl/Alt shortcuts are different: vscode-neovim forwards selected combinations
according to `vscode-neovim.ctrlKeysForNormalMode` and
`vscode-neovim.ctrlKeysForInsertMode`. Its default normal-mode Ctrl+K forwarding
can consume VS Code's Ctrl+K chords. If those chords are needed, remove `k` from
the normal-mode forwarding list, retaining the other entries you want. This is
an extension-default conflict, not a new leader-binding conflict.

After Explorer, SCM, a search box, or the terminal receives focus, these Neovim
leader sequences no longer apply. Use native shortcuts/list navigation and return
focus to a text editor before using them. In particular, `Space tt` opens the
integrated terminal from the editor; it is not a terminal-side escape shortcut.

To return to editing with VS Code's default Linux/Windows shortcuts:

| Current focus | Return to editor |
|---|---|
| Quick Open / command palette | `Esc` cancels; `Enter` accepts a selection |
| Explorer / Search sidebar | `Ctrl+1` focuses the first editor group |
| Any view, preserving the active editor group | Run `View: Focus Active Editor Group` from the command palette |

`Ctrl+1` selects group 1, so with multiple editor groups use the active-group
command to return without choosing a particular group. `Esc` alone does not
reliably leave a sidebar search field without a client shortcut. The NixOS
configuration's `docs/vscode-neovim.md` documents the scoped Explorer/Search
Escape shortcut artifact and its client installation. These are native VS Code
shortcuts, not Neovim mappings, and custom user bindings can override them.

## Shortcut Help In VS Code

In normal mode, `Space k` opens a native VS Code Quick Pick generated from the
loaded, described normal and visual mappings. Type to filter by key sequence or
action description, then select a result to run that mapping. This includes direct
keys such as `gd`, `H`, and `L`, leader mappings, and visual text objects such as
`Visual if`. Selecting a visual mapping enters Visual mode before running it.
Operator-pending mappings, native motions, and plugin-local mappings without
descriptions are not listed.
The `vsCodeSlim` profile disables the Neovim Which Key and cheatsheet plugins.
The picker uses the vscode-neovim extension API and does not require a separate
Which Key VS Code extension.

Optionally add the following entry through
`Preferences: Open Keyboard Shortcuts (JSON)` on the client to open the search
picker on the first Space in normal mode:

```json
{
  "key": "space",
  "command": "vscode-neovim.send",
  "args": " k",
  "when": "editorTextFocus && neovim.init && neovim.mode == normal && !inQuickOpen && !suggestWidgetVisible"
}
```

Installing the full VSpaceCode or VSCodeVim stack is not required.

For Dvorak, these mappings follow characters, not physical QWERTY key positions.
Keep the active OS layout correct. If a key is intercepted or misidentified, use
`Developer: Toggle Keyboard Shortcuts Troubleshooting` and
`Developer: Inspect Key Mapping` before changing `keyboard.dispatch`. Local/client
user keybindings are not validated by this repository's headless checks.

## Validation

The profile checks verify that the task mappings and surround grammar load in
both profiles, that the slim profile excludes standalone-only shortcuts, and
that representative editing behavior still works:

```bash
nix build .#checks.x86_64-linux.full .#checks.x86_64-linux.vsCodeSlim
nix build .#full .#vsCodeSlim
```

Headless checks exercise surround edits, selection-preserving indentation,
assistant command ranges, and VS Code action dispatch through a stubbed bridge.
They do not execute VS Code commands. Interactive host behavior, Git operations,
terminal keys, local shortcut conflicts, and Quick Pick usability still require a
VS Code session. Command IDs must also be supported by the installed VS Code
version and its built-in Git extension.
