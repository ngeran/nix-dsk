{ config, pkgs, ... }:

let
  lmstudioWrapped = pkgs.stdenv.mkDerivation rec {
    pname = "lmstudio-wrapper";
    version = "0.1";

    src = null; # no source to unpack

    buildInputs = [ pkgs.makeWrapper pkgs.lmstudio pkgs.qt5.qtbase pkgs.libGL ];

    installPhase = ''
      mkdir -p $out/bin
      makeWrapper ${pkgs.lmstudio}/bin/lmstudio $out/bin/lmstudio \
        --set LD_LIBRARY_PATH ${pkgs.qt5.qtbase}/lib:${pkgs.libGL}/lib \
        --set QT_QPA_PLATFORM xcb \
        --set OZONE_PLATFORM_HINT auto
    '';
  };
in {
  home.packages = [ lmstudioWrapped ];

  xdg.desktopEntries.lm-studio = {
    name = "LM Studio";
    exec = "lmstudio";
    icon = "lmstudio";
    type = "Application";
    comment = "Desktop App for running local LLMs";
  };
}
