# stylix.nix
{ pkgs, inputs, ... }:

{
  # Imports the Stylix Home Manager module from your flake inputs.
  imports = [ inputs.stylix.homeModules.stylix ];

  # It is crucial to install the font packages in your home environment.
  # This ensures the system can find and use them.
  home.packages = with pkgs; [
    # Explicitly install the MesloLGS Nerd Font.
    meslo-lgs-nf
    # Install the Noto fonts for sans-serif, serif, and emojis.
    noto-fonts
    noto-fonts-emoji
    # The Papirus icon theme package is also needed if you want it applied.
    papirus-icon-theme
  ];

  # Main Stylix configuration block.
  stylix = {
    # Re-enable Stylix to apply your theme.
    enable = true;

    # Set the overall theme polarity to dark.
    polarity = "dark";

    # Use a pre-defined Base16 scheme.
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

    # Configure the opacity.
    opacity = {
      applications = 1.0;
      terminal = 0.8;
      desktop = 1.0;
      popups = 1.0;
    };

    # Re-enable Stylix for your chosen applications.
    targets = {
      yazi.enable = true;
      tmux.enable = true;
      firefox.enable = true;
      alacritty.enable = true;
      # The rest are disabled as per your original configuration.
      neovim.enable = false;
      waybar.enable = false;
      wofi.enable = false;
      hyprland.enable = false;
      hyprlock.enable = false;
      nixvim.enable = false;
    };



    # Configure the cursor theme.
    cursor = {
      name = "DMZ-Black";
      size = 24;
      package = pkgs.vanilla-dmz;
    };

    # Configure the fonts.
    fonts = {
      emoji = {
        name = "Noto Color Emoji";
        package = pkgs.noto-fonts-color-emoji;
      };
      # This is where you specify the MesloLGS Nerd Font.
      monospace = {
        name = "MesloLGS NF";
        package = pkgs.meslo-lgs-nf;
      };
      sansSerif = {
        name = "Noto Sans";
        package = pkgs.noto-fonts;
      };
      serif = {
        name = "Noto Serif";
        package = pkgs.noto-fonts;
      };

      sizes = {
        terminal = 12;
        applications = 12;
      };
    };

    # Configure the icon theme.
    iconTheme = {
      enable = true;
      package = pkgs.papirus-icon-theme;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
    };

    # Set the background image.
    image = pkgs.fetchurl {
      url = "https://codeberg.org/lunik1/nixos-logo-gruvbox-wallpaper/raw/branch/master/png/gruvbox-dark-blue.png";
      sha256 = "1jrmdhlcnmqkrdzylpq6kv9m3qsl317af3g66wf9lm3mz6xd6dzs";
    };
  };
}
