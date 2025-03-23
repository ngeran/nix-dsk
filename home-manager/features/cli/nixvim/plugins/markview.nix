{
  programs.nixvim = {
    plugins = {
      copilot-cmp = {
        enable = true;
      };
      copilot-lua = {
        enable = true;
        settings = {
          copilot = {
            suggestion = {
              enabled = false;
            };
            panel = {
              enabled = false;
            };
          };
        };
      };
      markview = {
        enable = true;
        settings = {
          buf_ignore = [ ];
          hybrid_modes = [
            "i"
          ];
          modes = [
            "n"
            "i"
            "no"
            "c"
          ];
          callbacks.on_enable.__raw = ''
            function(_, win)
              vim.wo[win].conceallevel = 2
              vim.wo[win].concealcursor = "nc"
            end
          '';
        };
      };
    };
    extraConfigLua = ''
      require("copilot").setup({
        suggestion = { enabled = false },
        panel = { enabled = false },
      })
    '';
  };
}