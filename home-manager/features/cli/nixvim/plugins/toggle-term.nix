{ config, lib, ... }:

{
  programs.nixvim = {
    plugins.toggleterm = {
      enable = true;

      lazyLoad = {
        settings = {
          cmd = "ToggleTerm";
          keys = [
            "<leader>tg"
            "<leader>gg"
          ];
        };
      };

      settings = {
        direction = "float";
      };
    };

    keymaps = lib.mkIf config.programs.nixvim.plugins.toggleterm.enable [
      {
        mode = "n";
        key = "<leader>tt";
        action = "<cmd>ToggleTerm<CR>";
        options = {
          desc = "Open Terminal";
        };
      }
      (lib.mkIf
        (
          !(config.programs.nixvim.plugins.snacks.enable or false)
          || (!(config.programs.nixvim.plugins.snacks.settings.lazygit.enabled or false))
        )
        {
          mode = "n";
          key = "<leader>tg";
          action.__raw = ''
            function()
              local toggleterm = require('toggleterm.terminal')

              toggleterm.Terminal:new({cmd = 'lazygit',hidden = true}):toggle()
            end
          '';
          options = {
            desc = "Open Lazygit";
            silent = true;
          };
        }
      )
      (lib.mkIf
        (
          !(config.programs.nixvim.plugins.snacks.enable or false)
          || (!(config.programs.nixvim.plugins.snacks.settings.lazygit.enabled or false))
        )
        {
          mode = "n";
          key = "<leader>gg";
          action.__raw = ''
            function()
              local toggleterm = require('toggleterm.terminal')

              toggleterm.Terminal:new({cmd = 'lazygit',hidden = true}):toggle()
            end
          '';
          options = {
            desc = "Open Lazygit";
            silent = true;
          };
        }
      )
    ];

    plugins.snacks = {
      enable = true;
      settings = {
        lazygit = {
          enabled = false;
        };
      };
    };
  };
}