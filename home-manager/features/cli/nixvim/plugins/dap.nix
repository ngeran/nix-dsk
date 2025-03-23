{
  programs.nixvim = {
    plugins.dap = {
      enable = true; 
    };
    plugins.dap-python = {
      enable = true; 
    };

  };
}