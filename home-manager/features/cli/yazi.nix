{
  programs.yazi = {
    enable = true;
    settings = {
      theme = {
        name = "gruvbox-dark"; # The name (without .toml)
      };
    };
    file."theme.toml" = { # Deploy the theme file to the correct location
      source = ./themes/yazi/gruvbox-dark.toml; # Adjust the path if your file is elsewhere
      target = ".config/yazi/theme.toml";
    };
  };
}
