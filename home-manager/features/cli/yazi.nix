{ config, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    settings = {
      theme = {
        name = "my_custom_theme"; # Or a built-in theme
        # path = "/path/to/your/custom_theme.toml"; # If the file is elsewhere
      };
    };
    # You could also deploy a custom theme file:
    file.yazi_theme = {
      source = ./my_custom_theme.toml; # Assuming the theme file is in the same directory as your home.nix
      target = ".config/yazi/gruvbox_theme.toml";
    };
  };
}
