{
  programs.nixvim = {
    plugins.dap = {
      enable = true;
      dap-python.enable = true;  
    };
  };
}