{
  programs.nixvim = {
    plugins.copilot-lua = {
      enable = true;
      settings = {
        copilot = {
          node_command = "/home/nikos/.nix-profile/bin/node";
        };
      };
    };
  };
}
