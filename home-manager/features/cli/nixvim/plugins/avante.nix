{
  config,
  lib,
  pkgs,
  ...
}:
{
  # Extra plugins that are conditionally enabled
  extraPlugins = lib.mkIf config.plugins.copilot-vim.enable [
    pkgs.vimPlugins.copilot-vim
  ];

  # Plugin configuration
  plugins = {
    avante = {
      enable = true;
      package = pkgs.vimPlugins.avante-nvim.overrideAttrs {
        patches = [
          # Patch for Avante if needed
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

    copilot-vim = {
      enable = true;
      package = pkgs.vimPlugins.copilot-vim.overrideAttrs (oldAttrs: {
        patches = [
          # Optionally, if you want to apply a patch
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
  };

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

  # NixVim program configuration
  programs.nixvim = {
    plugins.avante = {
      enable = true;
    };
    plugins.copilot-vim = {
      enable = true;
    };
  };
}