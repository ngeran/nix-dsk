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
    source = .config/yazi/config/gruvbox-dark.toml;
  };
}
