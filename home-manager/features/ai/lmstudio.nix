{ config, pkgs, ... }:

let
  lmstudio-package = pkgs.stdenv.mkDerivation rec {
    pname = "lm-studio";
    version = "0.2.22"; # Adjust if needed
    src = ./lm-studio-0.2.22-linux-x64.tar.gz; # Path to local tarball

    nativeBuildInputs = [
      pkgs.makeWrapper
      pkgs.autoPatchelfHook
    ];

    buildInputs = [
      pkgs.glibc
      pkgs.zlib
      pkgs.libGL
      pkgs.qt5.qtbase
    ];

    unpackPhase = ''
      tar -xzf $src
    '';

    installPhase = ''
      mkdir -p $out/bin $out/share
      cp -r . $out/share/lmstudio
      makeWrapper $out/share/lmstudio/LM\ Studio $out/bin/lmstudio
    '';
  };
in {
  home.packages = [ lmstudio-package ];

  xdg.desktopEntries.lm-studio = {
    name = "LM Studio";
    exec = "lmstudio";
    icon = "lmstudio"; # replace with path if no icon in /usr/share/icons
    type = "Application";
    comment = "Desktop App for running local LLMs";
  };
}
