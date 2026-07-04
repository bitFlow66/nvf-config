# Feature: languages
# Language support: LSP, formatter, treesitter, extra diagnostics, and DAP per lang.
{ config, pkgs, lib, ... }: let
  inherit (lib.generators) mkLuaInline;
in {
  config.vim = {
    languages = {
      enableFormat = true;
      enableTreesitter = true;
      enableExtraDiagnostics = true;
      enableDAP = true;

      nix.enable = true;
      markdown = {
        enable = true;
        lsp.enable = true;
        format.type = ["deno"];
        extensions.render-markdown-nvim.enable = true;
        extraDiagnostics.types = ["markdownlint-cli2"];
      };
      bash.enable = true;
      clang.enable = true;
      lua.enable = true;
      zig = {
        enable = true;
        lsp.enable = true;
        dap.enable = true;
      };
      python = {
        enable = true;
        lsp.enable = true;
        format.type = ["black"];
        dap.enable = true;
        extraDiagnostics.types = ["mypy"];
      };
      rust = {
        enable = true;
        extensions.crates-nvim.enable = true;
      };
      csharp = {
        enable = true;
        lsp.enable = true;
        format.type = ["csharpier"];
      };
      yaml = {
        enable = true;
        lsp.enable = true;
        format.type = ["prettier"];
      };

      nim.enable = false; # LSP broken on Darwin
    };

    # LSP from system PATH — keep presets enabled (they provide root_markers,
    # filetypes, settings, etc.) but override cmd to use plain binary names
    # so lspconfig resolves them from $PATH at runtime, not from the Nix store.
    lsp.servers = {
      zls.cmd = lib.mkForce ["zls"];
      marksman.cmd = lib.mkForce ["marksman" "server"];
      yaml-language-server.cmd = lib.mkForce ["yaml-language-server" "--stdio"];
      basedpyright.cmd = lib.mkForce ["basedpyright-langserver" "--stdio"];
      csharp_ls.cmd = lib.mkForce ["csharp-ls"];
    };

    # DAP adapter for C# / .NET via netcoredbg (from PATH)
    debugger.nvim-dap = {
      adapters = {
        coreclr = {
          type = "executable";
          command = "netcoredbg";
          args = ["--interpreter=vscode"];
        };
      };
      configurations = {
        cs = [
          {
            type = "coreclr";
            request = "launch";
            name = "Launch .NET Core";
            preLaunchTask = "build";
            program = mkLuaInline ''
              function()
                return vim.fn.input(
                  'Path to DLL: ',
                  vim.fn.getcwd() .. '/bin/Debug/',
                  'file'
                )
              end
            '';
            cwd = mkLuaInline "function() return vim.fn.getcwd() end";
            console = "internalConsole";
            stopAtEntry = false;
          }
        ];
      };
    };
  };
}
