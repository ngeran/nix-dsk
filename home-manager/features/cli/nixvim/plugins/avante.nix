{
  config,
  lib,
  pkgs,
  ...
}:
{
  programs.nixvim = {
    plugins = {
      # Configure avante plugin
      avante = {
        enable = true;
        package = pkgs.vimPlugins.avante-nvim.overrideAttrs {
          patches = [
            # Optionally, patch Avante plugin
            (pkgs.fetchpatch {
              url = "https://github.com/doodleEsc/avante.nvim/commit/a5438d0f16208b7ae9e97ae354bed5ec16b4f9ed.patch";
              hash = "sha256-KyfO9dE27yMXOQhpit7jmzkvnfM7b5kr2Acoh011lXA=";
            })
          ];
        };
        settings = {
          mappings = {
            files = {
              add_current = "<leader>a.";  # Avante mapping
            };
          };
        };
      };

      # Configure copilot-lua plugin, disable copilot-vim
      copilot-lua = {
        enable = true;  # Enable copilot-lua here
      };

      # Disable copilot-vim if you are using copilot-lua
      copilot-vim = {
        enable = false;  # Disable copilot-vim here
      };
    };

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
