{ config, pkgs, ... }:

{
  # All local definitions using 'let' must go here, BEFORE the 'in' keyword.
  let
    lmstudio-package = pkgs.stdenv.mkDerivation rec {
      pname = "lm-studio";
      version = "0.2.22"; # Replace with the actual version
      src = ./lm-studio-0.2.22-linux-x64.tar.gz; # Path to the local tarball
      nativeBuildInputs = [ pkgs.makeWrapper pkgs.autoPatchelfHook ];
      buildInputs = [
        pkgs.glibc
        pkgs.zlib
        # Add other dependencies if needed, e.g., pkgs.libGL, pkgs.qt5.qtbase
      ];

      # Unpack the tarball explicitly
      unpackPhase = ''
        tar -xzf $src
      '';

      installPhase = ''
        mkdir -p $out/bin $out/share
        cp -r . $out/share/lmstudio
        makeWrapper $out/share/lmstudio/LM\ Studio $out/bin/lmstudio
      '';
    };
  in
  # All the attributes for your configuration go here, after the 'in' keyword.
  {
    home.packages = [ lmstudio-package ];

    xdg.desktopEntries.lm-studio = {
      name = "LM Studio";
      exec = "lmstudio";
      icon = "lmstudio"; # Ensure the icon file exists or provide a path
      type = "Application";
      comment = "Desktop App for running local LLMs";
    };
  }
}
