{
  programs.nixvim = {
    plugins.dap = {
      enable = true; 
    };
    plugins.dap-python = {
      enable = true; 
    };
    plugins.dap-ui = {
      enable = true; 
    };

  };
}