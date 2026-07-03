# Feature: assistant
# AI coding assistants: Copilot (with cmp) and CodeCompanion (with Ollama).
{ config, pkgs, lib, ... }: {
  config.vim.assistant = {
    chatgpt.enable = false;
    copilot = {
      enable = true;
      cmp.enable = true;
    };
    codecompanion-nvim = {
      enable = true;
      setupOpts = {
        opts.send_code = true;
        display.chat.auto_scroll = true;
        strategies = {
          inline.adapter = "ollama";
          chat.adapter = "ollama";
          cmd.adpater = "ollama";
        };
      };
    };
  };
}
