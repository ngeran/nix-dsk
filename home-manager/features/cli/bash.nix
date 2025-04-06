{ config, ... }: {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    # Add a reference to your starship.toml file
    shellInit = ''
      export STARSHIP_CONFIG="$HOME/.config/starship.toml"
    '';
  };
}
