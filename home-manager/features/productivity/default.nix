{ pkgs, ... }: {

  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [

    # Desktop apps
#     inkscape-with-extensions
#     krita
#     kicad
#     dropbox
#     logseq has problem with - Electron version 27.3.11 is EOL
  ];
}