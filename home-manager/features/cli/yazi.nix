{ config, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    settings = {
      theme = {
        name = "gruvbox-dark"; # Assuming your file is named gruvbox-dark.toml
      };
    };
  };

  home.file.".config/yazi/theme.toml" = {
    source = ./themes/yazi/gruvbox-dark.toml; # Adjust the path to your theme file
  };
}
