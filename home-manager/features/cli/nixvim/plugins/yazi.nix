{ config, lib, ... }:

{
  programs.nixvim = {
    enable = true;
    plugins.yazi = {
      enable = true;

      lazyLoad = {
        settings = {
          cmd = [
            "Yazi"
          ];
        };
      };
    };

    keymaps = lib.optionals config.programs.nixvim.plugins.yazi.enable [
      {
        mode = "n";
        key = "<leader>e";
        action = "<CMD>Yazi<CR>";
        options = {
          desc = "Yazi (current file)";
        };
      }
      {
        mode = "n";
        key = "<leader>E";
        action = "<CMD>Yazi toggle<CR>";
        options = {
          desc = "Yazi (resume)";
        };
      }
    ];
  };
}