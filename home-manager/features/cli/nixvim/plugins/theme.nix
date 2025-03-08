{ ... }:
{
    programs.nixvim = {
        colorschemes.catppuccin = {
    settings = {
      default_integrations = true;
      flavour = "macchiato";
      show_end_of_buffer = true;
      term_colors = true;
      transparent_background = false;

      integrations = {
        cmp = true;
        blink_cmp = true;
        gitsigns = true;
        lsp_trouble = true;
        markdown = true;
        mini.enabled = true;
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
            background = true;
          };
        };
        treesitter = true;

      };
    };
  };
    };
}