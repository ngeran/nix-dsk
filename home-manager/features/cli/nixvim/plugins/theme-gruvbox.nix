{
  programs.nixvim = {
    enable = true;  # Ensure Nixvim is enabled
    colorschemes.gruvbox = {
      enable = true;  # Enable Gruvbox colorscheme
      settings = {
        # Gruvbox-specific options
        contrast = "hard";  # Options: "hard", "medium", "soft" (affects background contrast)
        palette_overrides = {
          # Optional: Customize palette colors (example values)
          dark0_hard = "#1d2021";  # Darker background for "hard" contrast
          bright_red = "#fb4934";  # Adjust red tones
        };
        italicize_comments = true;  # Italicize comments
        italicize_strings = false;  # Don’t italicize strings
        invert_selection = false;  # Don’t invert selection colors
        improved_strings = true;  # Better string highlighting
        improved_warnings = true;  # Enhanced warning visibility
        transparent_background = false;  # Solid background
        term_colors = true;  # Use terminal colors

        # Integrations (similar to your Catppuccin example)
        integrations = {
          cmp = true;  # Completion menu
          gitsigns = true;  # Git signs in gutter
          lsp_trouble = true;  # LSP diagnostics Trouble plugin
          markdown = true;  # Markdown rendering
          mini = {
            enabled = true;  # Mini.nvim plugin suite
          };
          native_lsp = {
            enabled = true;
            virtual_text = {
              errors = [ "italic" ];
              hints = [ "italic" ];
              warnings = [ "italic" ];
              information = [ "italic" ];
            };
            underlines = {
              errors = [ "underline" ];
              hints = [ "underline" ];
              warnings = [ "underline" ];
              information = [ "underline" ];
            };
            inlay_hints = {
              background = true;  # Background for inlay hints
            };
          };
          treesitter = true;  # Syntax highlighting via Treesitter
        };
      };
    };
  };
}