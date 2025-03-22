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

      # Configure copilot-vim plugin, disable copilot-lua
      copilot-vim = {
        enable = true;
        package = pkgs.vimPlugins.copilot-vim.overrideAttrs (oldAttrs: {
          patches = [
            # Optionally, patch Copilot plugin
            (pkgs.fetchpatch {
              url = "https://github.com/github/copilot.vim/commit/somecommit.patch";
              hash = "sha256-somehashhere=";
            })
          ];
        });

        settings = {
          mappings = {
            copilot_accept = "<leader>ac";  # Customize mapping for Copilot accept
          };
        };
      };

      # Explicitly disable copilot-lua in the plugins section
      copilot-lua = {
        enable = false;  # Ensure copilot-lua is disabled when using copilot-vim
      };
    };

    # Directly add keymaps for both plugins without which-key
    keymaps = lib.optionals config.plugins.avante.enable [
      {
        mode = "n";
        key = "<leader>ac";
        action = "<CMD>AvanteClear<CR>";
        options.desc = "avante: clear";
      }
    ] ++ lib.optionals config.plugins.copilot-vim.enable [
      {
        mode = "n";
        key = "<leader>ac";
        action = "<CMD>CopilotAccept<CR>";  # Copilot accept action
        options.desc = "copilot-vim: accept suggestion";
      }
    ];
  };
}
