# Feature: keymaps
# Shared Dvorak-friendly task bindings with profile-specific command dispatch.
{
  lib,
  vscode,
  ...
}: let
  vscodeAction = command: "<cmd>lua require('vscode').action('${command}')<CR>";
  telescopeAction = name: "<cmd>Telescope ${name}<CR>";
  lspAction = name: "<cmd>lua vim.lsp.buf.${name}()<CR>";
  mappings =
    [
      # Keep visual indentation and preserve the selection.
      {
        key = ">";
        mode = "x";
        silent = true;
        action = ">gv";
      }
      {
        key = "<";
        mode = "x";
        silent = true;
        action = "<gv";
      }

      # Files and search.
      {
        key = "<leader><leader>";
        mode = "n";
        desc = "Find files";
        action =
          if vscode
          then vscodeAction "workbench.action.quickOpen"
          else telescopeAction "find_files";
      }
      {
        key = "<leader>e";
        mode = "n";
        desc = "Explorer";
        action =
          if vscode
          then vscodeAction "workbench.view.explorer"
          else "<cmd>Neotree toggle<CR>";
      }
      {
        key = "<leader>fr";
        mode = "n";
        desc = "Recent files";
        action =
          if vscode
          then vscodeAction "workbench.action.openRecent"
          else telescopeAction "oldfiles";
      }
      {
        key = "<leader>fs";
        mode = "n";
        desc = "Save file";
        action = "<cmd>write<CR>";
      }
      {
        key = "<leader>sg";
        mode = "n";
        desc = "Search project text";
        action =
          if vscode
          then vscodeAction "workbench.action.findInFiles"
          else telescopeAction "live_grep";
      }
      {
        key = "<leader>st";
        mode = "n";
        desc = "Search TODOs";
        action =
          if vscode
          then "<cmd>lua require('vscode').action('workbench.action.findInFiles', {args = {query = 'TODO|FIXME|HACK|WARN|PERF|NOTE', isRegex = true}})<CR>"
          else "<cmd>TodoTelescope<CR>";
      }
      {
        key = "<leader>sw";
        mode = "n";
        desc = "Search word under cursor";
        action =
          if vscode
          then "<cmd>lua require('vscode').action('workbench.action.findInFiles', {args = {query = vim.fn.expand('<cword>'), isRegex = false}})<CR>"
          else telescopeAction "grep_string";
      }
      {
        key = "<leader>ss";
        mode = "n";
        desc = "Document symbols";
        action =
          if vscode
          then vscodeAction "workbench.action.gotoSymbol"
          else telescopeAction "lsp_document_symbols";
      }
      {
        key = "<leader>sS";
        mode = "n";
        desc = "Workspace symbols";
        action =
          if vscode
          then vscodeAction "workbench.action.showAllSymbols"
          else telescopeAction "lsp_workspace_symbols";
      }
      {
        key = "<leader>k";
        mode = "n";
        desc = "Shortcut help";
        action =
          if vscode
          then "<cmd>lua NvfWhichKey()<CR>"
          else "<cmd>Cheatsheet<CR>";
      }

      # Buffers use mnemonic previous/next keys rather than bracket positions.
      {
        key = "<leader>bb";
        mode = "n";
        desc = "Open buffers";
        action =
          if vscode
          then vscodeAction "workbench.action.showAllEditors"
          else telescopeAction "buffers";
      }
      {
        key = "<leader>bd";
        mode = "n";
        desc = "Close buffer";
        action =
          if vscode
          then vscodeAction "workbench.action.closeActiveEditor"
          else "<cmd>lua require('bufdelete').bufdelete(0, false)<CR>";
      }
      # Preserve Vim's g-prefixed navigation grammar across editors.
      {
        key = "gd";
        mode = "n";
        desc = "Go to definition";
        action =
          if vscode
          then vscodeAction "editor.action.revealDefinition"
          else lspAction "definition";
      }
      {
        key = "gD";
        mode = "n";
        desc = "Go to declaration";
        action =
          if vscode
          then vscodeAction "editor.action.revealDeclaration"
          else lspAction "declaration";
      }
      {
        key = "gy";
        mode = "n";
        desc = "Go to type definition";
        action =
          if vscode
          then vscodeAction "editor.action.goToTypeDefinition"
          else lspAction "type_definition";
      }
      {
        key = "grr";
        mode = "n";
        desc = "Find references";
        action =
          if vscode
          then vscodeAction "editor.action.goToReferences"
          else lspAction "references";
      }
      {
        key = "gri";
        mode = "n";
        desc = "Go to implementations";
        action =
          if vscode
          then vscodeAction "editor.action.goToImplementation"
          else lspAction "implementation";
      }
      {
        key = "K";
        mode = "n";
        desc = "Hover documentation";
        action =
          if vscode
          then vscodeAction "editor.action.showHover"
          else lspAction "hover";
      }

      # Code actions and formatting.
      {
        key = "<leader>ca";
        mode = "n";
        desc = "Code action";
        action =
          if vscode
          then vscodeAction "editor.action.quickFix"
          else lspAction "code_action";
      }
      {
        key = "<leader>cr";
        mode = "n";
        desc = "Rename symbol";
        action =
          if vscode
          then vscodeAction "editor.action.rename"
          else lspAction "rename";
      }
      {
        key = "<leader>cf";
        mode = "n";
        desc = "Format document";
        action =
          if vscode
          then vscodeAction "editor.action.formatDocument"
          else "<cmd>lua require('conform').format({async = true})<CR>";
      }
      {
        key = "<leader>cf";
        mode = "x";
        desc = "Format selection";
        action =
          if vscode
          then vscodeAction "editor.action.formatSelection"
          else "<cmd>lua require('conform').format({async = true})<CR>";
      }
      {
        key = "<leader>cs";
        mode = "n";
        desc = "Signature help";
        action =
          if vscode
          then vscodeAction "editor.action.triggerParameterHints"
          else "<cmd>lua vim.lsp.buf.signature_help()<CR>";
      }

      # Diagnostics and results.
      {
        key = "<leader>xn";
        mode = "n";
        desc = "Next diagnostic";
        action =
          if vscode
          then vscodeAction "editor.action.marker.next"
          else "<cmd>lua vim.diagnostic.goto_next()<CR>";
      }
      {
        key = "<leader>xp";
        mode = "n";
        desc = "Previous diagnostic";
        action =
          if vscode
          then vscodeAction "editor.action.marker.prev"
          else "<cmd>lua vim.diagnostic.goto_prev()<CR>";
      }
      {
        key = "<leader>xd";
        mode = "n";
        desc = "Diagnostic details";
        action =
          if vscode
          then vscodeAction "editor.action.showHover"
          else "<cmd>lua vim.diagnostic.open_float()<CR>";
      }
      {
        key = "<leader>xx";
        mode = "n";
        desc = "Workspace diagnostics";
        action =
          if vscode
          then vscodeAction "workbench.actions.view.problems"
          else "<cmd>Trouble diagnostics toggle<CR>";
      }
      {
        key = "<leader>xb";
        mode = "n";
        desc =
          if vscode
          then "Problems panel"
          else "Buffer diagnostics";
        action =
          if vscode
          then vscodeAction "workbench.actions.view.problems"
          else "<cmd>Trouble diagnostics toggle filter.buf=0<CR>";
      }
      {
        key = "<leader>xq";
        mode = "n";
        desc =
          if vscode
          then "Problems panel"
          else "Quickfix list";
        action =
          if vscode
          then vscodeAction "workbench.actions.view.problems"
          else "<cmd>copen<CR>";
      }

      # Git changes use letters rather than Dvorak punctuation positions.
      {
        key = "<leader>gd";
        mode = "n";
        desc =
          if vscode
          then "File diff"
          else "Repository diff";
        action =
          if vscode
          then vscodeAction "git.openChange"
          else "<cmd>DiffviewOpen<CR>";
      }
      {
        key = "<leader>gn";
        mode = "n";
        desc = "Next change";
        action =
          if vscode
          then vscodeAction "editor.action.dirtydiff.next"
          else "<cmd>Gitsigns next_hunk<CR>";
      }
      {
        key = "<leader>gp";
        mode = "n";
        desc = "Previous change";
        action =
          if vscode
          then vscodeAction "editor.action.dirtydiff.previous"
          else "<cmd>Gitsigns prev_hunk<CR>";
      }
      {
        key = "<leader>gv";
        mode = "n";
        desc =
          if vscode
          then "Show next inline change"
          else "Preview change";
        action =
          if vscode
          then vscodeAction "editor.action.dirtydiff.next"
          else "<cmd>Gitsigns preview_hunk<CR>";
      }
      {
        key = "<leader>gh";
        mode = "n";
        desc =
          if vscode
          then "File timeline"
          else "File history";
        action =
          if vscode
          then vscodeAction "timeline.focus"
          else "<cmd>DiffviewFileHistory %<CR>";
      }
      {
        key = "<leader>gH";
        mode = "n";
        desc = "Repository history";
        action =
          if vscode
          then vscodeAction "workbench.scm.history.focus"
          else "<cmd>DiffviewFileHistory<CR>";
      }
      {
        key = "<leader>gs";
        mode = "n";
        desc =
          if vscode
          then "Stage changed lines"
          else "Stage hunk";
        action =
          if vscode
          then vscodeAction "git.stageSelectedRanges"
          else "<cmd>Gitsigns stage_hunk<CR>";
      }
      {
        key = "<leader>gu";
        mode = "n";
        desc =
          if vscode
          then "Unstage changed lines (index diff)"
          else "Undo stage hunk";
        action =
          if vscode
          then vscodeAction "git.unstageSelectedRanges"
          else "<cmd>Gitsigns undo_stage_hunk<CR>";
      }
      {
        key = "<leader>gr";
        mode = "n";
        desc =
          if vscode
          then "Revert change at cursor"
          else "Reset hunk";
        action =
          if vscode
          then vscodeAction "git.revertSelectedRanges"
          else "<cmd>Gitsigns reset_hunk<CR>";
      }

      # Debug actions are shared where the host provides a debugger.
      {
        key = "<leader>dc";
        mode = "n";
        desc =
          if vscode
          then "Continue debugging"
          else "Start or continue debugging";
        action =
          if vscode
          then vscodeAction "workbench.action.debug.continue"
          else "<cmd>lua require('dap').continue()<CR>";
      }
      {
        key = "<leader>db";
        mode = "n";
        desc = "Toggle breakpoint";
        action =
          if vscode
          then vscodeAction "editor.debug.action.toggleBreakpoint"
          else "<cmd>lua require('dap').toggle_breakpoint()<CR>";
      }
      {
        key = "<leader>di";
        mode = "n";
        desc = "Step into";
        action =
          if vscode
          then vscodeAction "workbench.action.debug.stepInto"
          else "<cmd>lua require('dap').step_into()<CR>";
      }
      {
        key = "<leader>do";
        mode = "n";
        desc = "Step over";
        action =
          if vscode
          then vscodeAction "workbench.action.debug.stepOver"
          else "<cmd>lua require('dap').step_over()<CR>";
      }
      {
        key = "<leader>dO";
        mode = "n";
        desc = "Step out";
        action =
          if vscode
          then vscodeAction "workbench.action.debug.stepOut"
          else "<cmd>lua require('dap').step_out()<CR>";
      }
      {
        key = "<leader>dC";
        mode = "n";
        desc = "Run to cursor";
        action =
          if vscode
          then vscodeAction "editor.debug.action.runToCursor"
          else "<cmd>lua require('dap').run_to_cursor()<CR>";
      }
      {
        key = "<leader>dr";
        mode = "n";
        desc = "Restart debugging";
        action =
          if vscode
          then vscodeAction "workbench.action.debug.restart"
          else "<cmd>lua require('dap').restart()<CR>";
      }
      {
        key = "<leader>dq";
        mode = "n";
        desc = "Stop debugging";
        action =
          if vscode
          then vscodeAction "workbench.action.debug.stop"
          else "<cmd>lua require('dap').terminate()<CR>";
      }
      {
        key = "<leader>de";
        mode = "n";
        desc = "Evaluate expression";
        action =
          if vscode
          then vscodeAction "editor.debug.action.showDebugHover"
          else "<cmd>lua require('dapui').eval()<CR>";
      }
      {
        key = "<leader>du";
        mode = "n";
        desc =
          if vscode
          then "Open Run and Debug"
          else "Toggle debug UI";
        action =
          if vscode
          then vscodeAction "workbench.view.debug"
          else "<cmd>lua require('dapui').toggle()<CR>";
      }

      # Toggles and optional tools.
      {
        key = "<leader>tf";
        mode = "n";
        desc = "Toggle format on save";
        action =
          if vscode
          then ''<cmd>lua require('vscode').eval_async([[const editor = vscode.window.activeTextEditor; if (!editor) return; const config = vscode.workspace.getConfiguration('editor', {uri: editor.document.uri, languageId: editor.document.languageId}); const target = vscode.workspace.workspaceFolders ? vscode.ConfigurationTarget.Workspace : vscode.ConfigurationTarget.Global; await config.update('formatOnSave', !config.get('formatOnSave'), target, true);]])<CR>''
          else "<cmd>lua vim.g.formatsave = not vim.g.formatsave<CR>";
      }
      {
        key = "<leader>tw";
        mode = "n";
        desc = "Toggle wrapping";
        action =
          if vscode
          then vscodeAction "editor.action.toggleWordWrap"
          else "<cmd>set wrap!<CR>";
      }
      {
        key = "<leader>tb";
        mode = "n";
        desc = "Toggle inline blame";
        action =
          if vscode
          then vscodeAction "git.blame.toggleEditorDecoration"
          else "<cmd>Gitsigns toggle_current_line_blame<CR>";
      }
    ]
    ++ lib.optionals (!vscode) [
      {
        key = "<leader>ts";
        mode = "n";
        desc = "Toggle spelling";
        action = "<cmd>set spell!<CR>";
      }
      {
        key = "<leader>gl";
        mode = "n";
        desc = "Blame line";
        action = "<cmd>Gitsigns blame_line<CR>";
      }
      {
        key = "<leader>aa";
        mode = "n";
        desc = "Assistant actions";
        action = "<cmd>CodeCompanionActions<CR>";
      }
      {
        key = "<leader>ac";
        mode = "n";
        desc = "Assistant chat";
        action = "<cmd>CodeCompanionChat<CR>";
      }
      {
        key = "<leader>as";
        mode = "x";
        desc = "Add selected lines to assistant chat";
        action = ":CodeCompanionChat Add<CR>";
      }
    ];
  bufferlineMappings = lib.optionalAttrs (!vscode) {
    vim.tabline.nvimBufferline.mappings = {
      closeCurrent = null;
      cycleNext = "<leader>bn";
      cyclePrevious = "<leader>bp";
    };
  };
  dapMappings = lib.optionalAttrs (!vscode) {
    vim.debugger.nvim-dap.mappings = {
      continue = null;
      restart = null;
      terminate = null;
      toggleRepl = null;
      hover = null;
      toggleBreakpoint = null;
      runToCursor = null;
      stepInto = null;
      stepOut = null;
      stepOver = null;
      stepBack = null;
      goUp = null;
      goDown = null;
      toggleDapUI = null;
    };
  };
  lspMappings = lib.optionalAttrs (!vscode) {
    vim.lsp.mappings = {
      goToDefinition = null;
      goToDeclaration = null;
      goToType = null;
      listImplementations = null;
      listReferences = null;
      nextDiagnostic = null;
      previousDiagnostic = null;
      openDiagnosticFloat = null;
      documentHighlight = null;
      listDocumentSymbols = null;
      addWorkspaceFolder = null;
      removeWorkspaceFolder = null;
      listWorkspaceFolders = null;
      listWorkspaceSymbols = null;
      hover = null;
      signatureHelp = null;
      renameSymbol = null;
      codeAction = null;
      format = null;
      toggleFormatOnSave = null;
    };
    vim.lsp.trouble.mappings = {
      workspaceDiagnostics = null;
      documentDiagnostics = null;
      lspReferences = null;
      quickfix = null;
      locList = null;
      symbols = null;
    };
  };
  toggletermMappings = lib.optionalAttrs (!vscode) {
    vim.terminal.toggleterm.mappings.open = "<leader>tt";
    vim.utility.motion.flash-nvim.mappings = {
      jump = "<leader>sj";
      treesitter = null;
      remote = null;
      treesitter_search = null;
      toggle = null;
    };
  };
  vscodeBufferMappings = lib.optionals vscode [
    {
      key = "<leader>bn";
      mode = "n";
      desc = "Next editor";
      action = vscodeAction "workbench.action.nextEditor";
    }
    {
      key = "<leader>bp";
      mode = "n";
      desc = "Previous editor";
      action = vscodeAction "workbench.action.previousEditor";
    }
    {
      key = "<leader>gg";
      mode = "n";
      desc = "Git overview";
      action = vscodeAction "workbench.view.scm";
    }
  ];
in {
  config = lib.mkMerge [
    bufferlineMappings
    dapMappings
    lspMappings
    toggletermMappings
    {
      vim.luaConfigRC.vscode-which-key = lib.mkIf vscode (lib.nvim.dag.entryAnywhere ''
        function NvfWhichKey()
          local menu = {}
          local categories = {
            b = "Buffers/editors", c = "Code", d = "Debug", f = "Files",
            g = "Git", s = "Search", t = "Toggles", x = "Diagnostics",
          }
          local function insert(items, keys, name, sequence)
            local key = keys:sub(1, 1)
            if #keys == 1 then
              items[#items + 1] = {
                key = key, name = name, type = "command",
                command = "vscode-neovim.send", args = sequence,
              }
              return
            end
            local group
            for _, item in ipairs(items) do
              if item.key == key then group = item; break end
            end
            if not group then
              group = {key = key, name = categories[key] or key, type = "bindings", bindings = {}}
              items[#items + 1] = group
            end
            insert(group.bindings, keys:sub(2), name, sequence)
          end
          local maps = vim.api.nvim_get_keymap("n")
          table.sort(maps, function(a, b) return a.lhs < b.lhs end)
          for _, map in ipairs(maps) do
            local lhs = map.lhs:gsub("<Space>", " ")
            if lhs:sub(1, 1) == " " and #lhs > 1 and map.desc then
              insert(menu, lhs:sub(2), map.desc, lhs)
            end
          end
          for _, item in ipairs(menu) do
            if item.key == "k" then
              item.command = "workbench.action.showCommands"
              item.args = nil
              item.name = "Command palette"
            end
          end
          require("vscode").action("whichkey.show", {args = {menu}})
        end
      '');
      vim.keymaps =
        mappings
        ++ vscodeBufferMappings
        ++ lib.optionals vscode [
          {
            key = "<leader>tt";
            mode = "n";
            desc = "Toggle terminal";
            action = vscodeAction "workbench.action.terminal.toggleTerminal";
          }
        ];
    }
  ];
}
