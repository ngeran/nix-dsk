{ pkgs, ... }: {
  nixvim.plugins.blink-cmp = {
    enable = true;
    package = pkgs.vimPlugins.blink-cmp;
    options = {
      use_history = true;        # Enable completions from Blink history (default: true)
      use_bookmarks = true;      # Enable completions from Blink bookmarks (default: true)
      use_tabs = true;           # Enable completions from currently open Blink tabs (default: true)
      suggestion_limit = 10;     # Maximum number of suggestions to display (default: 5)
      display_type = "full";     # How to display the type of completion ("full" or "short") (default: "full")
    };
  };
}
