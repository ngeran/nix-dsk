{ pkgs, ... }: {
  # This will allow packages that are not free to
  # be installed
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [

     # Desktop apps
     inkscape-with-extensions
     krita
     kicad
     obsidian
     vlc
     # CLI utils
     tree
     bash-completion
    # Coding stuff
     nodejs
     gnumake
     cmake
    # WM stuff
    libsForQt5.xwaylandvideobridge
    xdg-desktop-portal-gtk
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-wlr
    # Other
    bat
    tailwindcss
    hugo
    lua
    #Automation
    opentofu
    #Image
    imagemagick
    #browser
    tor-browser
    #NIXVIM
    fzf
    ripgrep
    glab
    ghostscript
    mermaid-cli
    fd
  ];
}
