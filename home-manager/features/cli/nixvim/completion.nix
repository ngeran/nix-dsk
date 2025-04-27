{
  programs.nixvim = {
    opts.completeopt = [
      "menu"
      "menuone"
      "noselect"
    ];

    plugins = {
      luasnip.enable = true;

      lspkind = {
        enable = true;

        cmp = {
          enable = true;
          menu = {
            nvim_lsp = "[LSP]";
            nvim_lua = "[api]";
            path = "[path]";
            luasnip = "[snip]";
            buffer = "[buffer]";
            neorg = "[neorg]";
            nixpkgs_maintainers = "[nixpkgs]";
          };
        };
      };

      cmp = {
        enable = false;  # Disable nvim-cmp since blink-cmp is taking over

        settings = {
          # The snippet.expand configuration is handled by blink-cmp internally
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";

          # Mapping changes can still be set to adjust keybinding behavior for completion
          mapping = {
            "<C-d>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<C-e>" = "cmp.mapping.close()";
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<S-Tab>" = "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
          };

          sources = [
            { name = "path"; }
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "buffer"; }
            { name = "neorg"; }
            { name = "nixpkgs_maintainers"; }
          ];
        };
      };

      # Enable blink-cmp for completion
      blink-cmp.enable = true;
      blink-cmp.settings = {
        keymap.preset = "super-tab";  # Or any other preferred keymap
        signature.enabled = true;

        sources = {
          default = [
            "buffer"
            "lsp"
            "path"
            "snippets"
            "copilot"
            "dictionary"
            "emoji"
            "git"
            "spell"
          ];
        };
      };
    };
  };
}
