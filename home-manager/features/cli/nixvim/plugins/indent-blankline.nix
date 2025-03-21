{ config, pkgs, lib, ... }:

{
  programs.nixvim = {
    enable = true;
    plugins = {
      indent-blankline = {
        enable =
          (!lib.hasAttr "indent" config.programs.nixvim.plugins.snacks.settings)
          || !config.programs.nixvim.plugins.snacks.settings.indent.enabled;

        lazyLoad.settings.event = "DeferredUIEnter";

        settings = {
          scope.enabled = false;
        };
      };
      snacks = {
        enable = true;
        settings = {
          indent = {
            enabled = true;
          };
        };
      };
    };

    keymaps = lib.optionals config.programs.nixvim.plugins.indent-blankline.enable [
      {
        mode = "n";
        key = "<leader>ui";
        action = "<cmd>IBLToggle<CR>";
        options = {
          desc = "Indent-Blankline toggle";
        };
      }
      {
        mode = "n";
        key = "<leader>uI";
        action = "<cmd>IBLToggleScope<CR>";
        options = {
          desc = "Indent-Blankline Scope toggle";
        };
      }
    ];
  };
}