{
  programs.nixvim.plugins = {
    copilot-vim = {
      enable = true;
      postBuild = ''
        mkdir -p $out/share/nvim/runtime/doc
        nvim -u NONE -i NONE -es +"helptags $out/share/nvim/runtime/doc" +q
      '';
    };

    copilot-chat = {
      enable = true;
      postBuild = ''
        mkdir -p $out/share/nvim/runtime/doc
        nvim -u NONE -i NONE -es +"helptags $out/share/nvim/runtime/doc" +q
      '';
    };
  };
}