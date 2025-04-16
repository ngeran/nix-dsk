{ config, pkgs, ... }: {
  programs.yazi = {
    enable = true;
    package = pkgs.yazi; # Ensures yazi package is available

    settings = {
      # Your Yazi settings go here in TOML format as a Nix attribute set
      manager = {
        show_hidden = true;
        sort_by = "natural";
        # Add other manager settings as needed
      };
      preview = {
        max_width = 80;
        max_height = 20;
        # Add other preview settings
      };
      # Define other Yazi sections like 'opener', 'keymap', etc.
      # following the Yazi TOML structure.
      opener.default = [
        { run = "xdg-open \"$@\""; block = false; }
      ];
    };

    theme = {
      # Your Yazi theme settings as a Nix attribute set
      filetype = {
        rules = [
          { fg = "#7AD9E5"; mime = "image/*"; }
          { fg = "#F3D398"; mime = "video/*"; }
          { fg = "#F3D398"; mime = "audio/*"; }
          { fg = "#CD9EFC"; mime = "application/x-bzip"; }
        ];
      };
      # Define other theme sections
    };

    keymap = {
      # Custom keybindings as a Nix attribute set
      manager.normal = [
        { key = "h"; action = "navigate_back"; }
        { key = "l"; action = "navigate_forward"; }
        # Add more keybindings
      ];
    };

    plugins = {
      # Configure Yazi plugins as an attribute set of paths or packages
      # example_plugin = pkgs.fetchFromGitHub { ... };
      # another_plugin = ./path/to/plugin;
    };

    initLua = null; # Path to a custom init.lua file if needed
  };
}
