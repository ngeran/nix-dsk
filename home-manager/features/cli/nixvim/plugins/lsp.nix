{ pkgs, ... }: {
  programs.nixvim = {
    enable = true;

    plugins = {
      lsp.enable = true;
      lsp.servers = {
        pylsp.enable = true;
        ruff.enable = true;
        rust_analyzer.enable = true;
      };
    };

    # Enable the blink-cmp plugin and set it up for LSP completions
    plugins.blink-cmp = {
      enable = true;
      setupLspCapabilities = true;

      settings = {
        keymap.preset = "super-tab";  # or another preset keybinding of your choice
        signature.enabled = true;

        sources = {
          default = [
            "buffer"
            "lsp"  # Ensures LSP sources are included for completion
            "path"
            "snippets"
            "copilot"
            "dictionary"
            "emoji"
            "git"
            "spell"
          ];
        };
      };
    };
  };
}
