{
  programs.nixvim = {
    opts.completeopt = [
      "menu"
      "menuone"
      "noselect"
    ];

    plugins = {
      # Snippet support
      luasnip.enable = true;

      # Icons and menu formatting for nvim-cmp
      lspkind = {
        enable = true;
        settings = {
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
      };

      # nvim-cmp core setup
      cmp = {
        enable = true;
        settings = {
          snippet.expand = "function(args) require('luasnip').lsp_expand(args.body) end";
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
    };
  };
}
