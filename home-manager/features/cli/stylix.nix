# stylix.nix
{ pkgs, inputs, ... }:

{
  # Imports the Stylix Home Manager module from your flake inputs.
  imports = [ inputs.stylix.homeModules.stylix ];

  # This section is for packages you need that are not directly handled by stylix.
  # We've removed redundant font packages since Stylix will handle them.
  home.packages = with pkgs; [
    # Example: If you need a utility like 'htop', you can add it here.
  ];

  # Main Stylix configuration block.
  stylix = {
    # Enable Stylix for your user. This is crucial for all other options to take effect.
    enable = true;

    # Set the overall theme polarity to dark. This influences the entire color scheme.
    polarity = "dark";

    # Use a pre-defined Base16 scheme. The Gruvbox Dark Hard theme is a popular choice.
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

    # Configure the opacity for different applications and UI elements.
    # Note: Opacity settings can sometimes be tricky and may not apply to all apps.
    opacity = {
      applications = 1.0; # Full opacity for general applications.
      terminal = 0.8;     # A bit of transparency for the terminal.
      desktop = 1.0;      # Full opacity for the desktop background.
      popups = 1.0;       # Full opacity for pop-up windows.
    };

    # Enable Stylix for specific applications.
    # We only enable the ones you want to be themed by Stylix.
    targets = {
      yazi.enable = true;
      tmux.enable = true;
      firefox.enable = true;
      alacritty.enable = true;
      # The applications below are disabled, so Stylix won't manage their styling.
      neovim.enable = false;
      waybar.enable = false;
      wofi.enable = false;
      hyprland.enable = false;
      hyprlock.enable = false;
      nixvim.enable = false;
    };

    # Configure the cursor theme.
    cursor = {
      name = "DMZ-Black"; # Name of the cursor theme.
      size = 24;           # Size of the cursor in pixels.
      package = pkgs.vanilla-dmz; # The package providing the cursor theme.
    };

    # Configure the fonts for different categories. 📚
    fonts = {
      # Use the "Noto Color Emoji" font for emoji support.
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };
      # **This is where you specify the MesloLGS Nerd Font.**
      # Stylix will apply this as the default monospace font for supported apps.
      monospace = {
        name = "MesloLGS NF";
        package = pkgs.meslo-lgs-nf;
      };
      # Set the sans-serif font for general UI elements.
      sansSerif = {
        name = "Noto Sans";
        package = pkgs.noto-fonts;
      };
      # Set the serif font.
      serif = {
        name = "Noto Serif";
        package = pkgs.noto-fonts;
      };

      # Set font sizes. 📐
      sizes = {
        terminal = 12;
        applications = 12;
      };
    };

    # Configure the icon theme.
    iconTheme = {
      enable = true;
      package = pkgs.adwaita-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    # Set the background image. You can use a local path or a fetched URL.
    image = pkgs.fetchurl {
      url = "https://codeberg.org/lunik1/nixos-logo-gruvbox-wallpaper/raw/branch/master/png/gruvbox-dark-blue.png";
      sha256 = "1jrmdhlcnmqkrdzylpq6kv9m3qsl317af3g66wf9lm3mz6xd6dzs";
    };
  };
}
