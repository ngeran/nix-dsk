{ pkgs, ... }: {
  programs.nixvim = {
    enable = true;
    
    plugins = {
      lsp.enable = true;
      lsp.servers = {
        pylsp.enable = true;
        ruff.enable = true; 
      };
    };
  };
}