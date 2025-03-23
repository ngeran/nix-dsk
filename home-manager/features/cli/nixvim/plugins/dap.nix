{
  programs.nixvim = {
    enable = true;

    plugins = {
      # Enable nvim-dap plugin
      'mfussenegger/nvim-dap' = {};
    };
  };
}
