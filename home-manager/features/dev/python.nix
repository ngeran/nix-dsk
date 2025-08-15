{
  pkgs,
  config,
  ...
}:
let
  jsnapy = pkgs.python3Packages.buildPythonPackage rec {
    pname = "jsnapy";
    version = "1.3.8";

    src = pkgs.fetchPypi {
      inherit pname version;
      sha256 = "b1a4c6f048af4b048ff843541da94384320876b80b0a8b97c99fb00b8614e57d";
    };

    propagatedBuildInputs = with pkgs.python3Packages; [
      junos-eznc
      pyyaml
      lxml
      colorama  # Add this if not already present; it's a dependency
    ];

    # Skip tests as they may require additional setup (e.g., nose) or network access
    doCheck = false;

    meta = with pkgs.lib; {
      description = "Junos Snapshot Administrator in Python";
      homepage = "https://github.com/Juniper/jsnapy";
      license = licenses.asl20;
      maintainers = [];  # Optional
    };
  };
in
{
  home = {
    packages = with pkgs; [
      # Python packages
      (python3.withPackages (pypkgs: with pypkgs; [
        pip
        requests
        setuptools
        matplotlib
        numpy
        torch
        jinja2
        types-jinja2
        types-pyyaml
        types-requests
        pyyaml
        flask
        junos-eznc
        netmiko
        mypy
        lxml
        openai
        gitpython
        paramiko
        tabulate
        prometheus_client
        git-filter-repo
        jsnapy  # Add this line
      ]))
    ];

    # Mypy cache directory
    sessionVariables.MYPY_CACHE_DIR = "${config.xdg.cacheHome}/mypy";
  };

  # Program configurations (unchanged)
  programs = {
    ruff = {
      enable = true;

      settings = {
        line-length = 100;
      };
    };

    nixvim = {
      filetype.extension.gin = "gin"; # inria
      files."after/ftplugin/python.lua" = {
        autoCmd = [
          {
            event = "BufWritePre";
            callback.__raw = ''
              function()
                vim.lsp.buf.code_action {
                  context = {only = {"source.fixAll.ruff"}},
                  apply = true
                }
              end
            '';
          }
        ];
      };
      plugins = {
        treesitter.languageRegister.python = [ "gin" ]; # inria
        lsp.servers = {
          ruff.enable = true;
          pylsp = {
            enable = true;
            settings = {
              plugins = {
                jedi_completion.fuzzy = true;
              };
            };
          };
        };
      };
    };
  };
}
