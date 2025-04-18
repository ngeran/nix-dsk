{ pkgs, inputs, ... }: {
  imports = [ inputs.stylix.homeManagerModules.stylix ]; # Imports the Stylix Home Manager module

  home.packages = with pkgs; [ # Installs fonts and related tools
    dejavu_fonts          # DejaVu fonts
    jetbrains-mono       # JetBrains Mono font
    noto-fonts           # Noto Sans and Serif fonts
    noto-fonts-emoji     # Noto Color Emoji font
    font-awesome         # Font Awesome icons
    powerline-fonts      # Powerline fonts
    powerline-symbols    # Powerline symbols
    nerd-fonts.symbols-only # Nerd Fonts symbols only
    meslo-lgs-nf  # Meslo LG Nerd Font
    nerd-fonts.hack      # Hack Nerd Font
    nerd-fonts.fira-mono # Fira Mono Nerd Font
  ];

  stylix = {
    enable = true; # Enables Stylix

    polarity = "dark"; # Sets the overall theme polarity to dark

    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";


    opacity = { # Configures opacity for different elements
      applications = 1.0; # Opacity for general applications
      terminal = 0.8;    # Opacity for the terminal
      desktop = 1.0;    # Opacity for the desktop
      popups = 1.0;     # Opacity for pop-up windows
    };

    targets = { # Enables Stylix for specific applications
      yazi.enable = false; # Enable Stylix for yazi
      firefox.enable = true; # Enables Stylix for Firefox
      alacritty.enable = true; # Enables Stylix for Alacritty
      neovim.enable = false; # Disables Stylix for Neovim (important!)
      waybar.enable = false; # Disables Stylix for Waybar
      wofi.enable = false;  # Disables Stylix for Wofi
      hyprland.enable = false; # Disables Stylix for Hyprland
      hyprlock.enable = false; # Disables Stylix for Hyprlock
      nixvim.enable = false; # Disables Stylix for nixvim
    };

    cursor = { # Configures the cursor
      name = "DMZ-Black"; # Cursor name
      size = 24;          # Cursor size
      package = pkgs.vanilla-dmz; # Package providing the cursor theme
    };

    fonts = { # Configures fonts
      emoji = {
      name = "Noto Color Emoji";
      package = pkgs.noto-fonts-color-emoji;
    };
    monospace = {
      name = "MesloLGS NF"; # Monospace font name for Alacritty
      package = pkgs.meslo-lgs-nf; # Nerd Font MesloLGS
    };
    sansSerif = {
      name = "Noto Sans";
      package = pkgs.noto-fonts;
    };
    serif = {
      name = "Noto Serif";
      package = pkgs.noto-fonts;
    };

    sizes = { # Font sizes for different elements
      terminal = 12;   # Font size for the terminal (Alacritty)
      applications = 12; # Font size for general applications
      };
    };
    iconTheme = { # Configures the icon theme
      enable = true; # Enables the icon theme
      package = pkgs.adwaita-icon-theme; # Package providing the icon theme
      dark = "Papirus-Dark";  # Dark icon theme
      light = "Papirus-Light"; # Light icon theme
    };

    # image = "/home/nikos/Downloads/gruvbox-dark-blue.png";
    image = pkgs.fetchurl { # Sets the background image (from the internet)
     # Rainbow
    #url = "https://codeberg.org/lunik1/nixos-logo-gruvbox-wallpaper/raw/branch/master/png/gruvbox-dark-rainbow.png"; # URL of the background image
    #sha256 = "036gqhbf6s5ddgvfbgn6iqbzgizssyf7820m5815b2gd748jw8zc"; # SHA256 hash for verification
     # Blue
      url = "https://codeberg.org/lunik1/nixos-logo-gruvbox-wallpaper/raw/branch/master/png/gruvbox-dark-blue.png";
      sha256 = "1jrmdhlcnmqkrdzylpq6kv9m3qsl317af3g66wf9lm3mz6xd6dzs";
     #Astronaut

     };
  };
}
