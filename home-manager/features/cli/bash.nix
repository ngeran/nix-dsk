{ config, ... }: {
  programs.bash = {
    enable = true;
    enableCompletion = true;
    # Shell initialization for Starship
    shellInit = ''
      # Initialize Starship prompt for Bash
      export STARSHIP_CONFIG="$HOME/.config/starship.toml"
      eval "$(starship init bash)"
    '';
  };
}
