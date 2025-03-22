{
  programs.nixvim = {
    # Enable the plugins section under programs.nixvim
    plugins = {
      # Configure avante plugin
      avante = {
        enable = true;
      };

      # Configure copilot-lua plugin, disable copilot-vim
      copilot-lua = {
        enable = true;  # Enable copilot-lua here
      };
    };  # This closes the plugins block

    # Add keymaps for both plugins without which-key
    keymaps = lib.optionals config.plugins.avante.enable [
      {
        mode = "n";
        key = "<leader>ac";
        action = "<CMD>AvanteClear<CR>";
        options.desc = "avante: clear";
      }
    ] ++ lib.optionals config.plugins.copilot-lua.enable [
      {
        mode = "n";
        key = "<leader>ac";
        action = "<CMD>CopilotAccept<CR>";  # Copilot accept action
        options.desc = "copilot-lua: accept suggestion";
      }
    ];
  };
}
