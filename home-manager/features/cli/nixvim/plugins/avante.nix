{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Ensure config.plugins is part of the configuration
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

      # Configure copilot-vim plugin
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
    };

    # which-key settings for both plugins
    which-key.settings.spec = lib.optionals config.plugins.avante.enable [
      {
        __unkeyed-1 = "<leader>a";
        group = "Avante";
        icon = "";
      }
    ] ++ lib.optionals config.plugins.copilot-vim.enable [
      {
        __unkeyed-1 = "<leader>ac";
        group = "Copilot";
        icon = "";  # You can replace the icon for Copilot
      }
    ];

    # Keymaps for both plugins
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
