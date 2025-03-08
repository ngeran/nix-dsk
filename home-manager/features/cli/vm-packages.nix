{ pkgs, ... }: {
  # This will allow packages that are not free to 
  # be installed
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [

    # Desktop apps
#     inkscape-with-extensions
#     krita
#     kicad
#     dropbox
#     logseq has problem with - Electron version 27.3.11 is EOL
  #   zathura
#     vlc
    # CLI utils
    tree
  #  helix
    # Coding stuff
    nodejs
    cargo
    rustc
    gnumake
    hugo 
    code-cursor
    # WM stuff
   libsForQt5.xwaylandvideobridge
#   libnotify
   xdg-desktop-portal-gtk
   xdg-desktop-portal-hyprland
   xdg-desktop-portal-wlr
    # Other
    bat
    tailwindcss
    # VPN 
    wireguard-tools
  ];
}

