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
     nodePackages.typescript
     nodePackages.typescript-language-server
     nodePackages.eslint
     nodePackages.prettier
     nodePackages.npm
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
    imagemagick
    #browser
    #NIXVIM
    fzf
    ripgrep
    glab
    ghostscript
    mermaid-cli
    fd
    git-lfs
    opencode
    #AI
    lmstudio
  ];
}
