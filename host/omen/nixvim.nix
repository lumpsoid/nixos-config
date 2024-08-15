{
  pkgs,
  config,
  ...
}:
{
  programs.nixvim = {
    enable = true;
    # We can set the leader key:
    globals.mapleader = " ";

    opts = {
      tabstop = 2;
      shiftwidth = 2;
      softtabstop = 2;
      expandtab = true;

      smartcase = true;
      ignorecase = true;
      hlsearch = true;

      termguicolors = true;

      number = true;
      relativenumber = true;
    };
    
    autoCmd = [
      {
        event = "FileType";
        pattern = "markdown";
        callback =  { __raw = ''
          function()
            vim.cmd([[
              set awa
              set com=b:-,n:>
              set formatoptions+=ro
            ]])
          end
        ''; };
      }
      { # as example for future
        event = [ "BufWritePost" ];
        pattern = "/home/qq/dotfiles/*";
        command = "!cd /home/qq/dotfiles; stow .";
      }
    ];

    extraFiles = {
      # path             source lua code file
      #"custom_functions".source = "";
    };

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
      };
    };

    plugins = {
      bufferline = {
        enable = true;
      };

      nvim-autopairs.enable = true;

      oil.enable = true;

      treesitter.enable = true;

      # completion
      cmp-nvim-lua.enable = true;
      cmp-path.enable = true;
      cmp-buffer.enable = true;
      luasnip = {
        enable = true;
        fromVscode = [ 
          {} 
          # { path = ./snippets; } # for the future
        ];
      };
      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          sources = [
            {name = "nvim_lsp";}
            {name = "luasnip";}
            {name = "path";}
            {name = "buffer";}
          ];
          snippet.expand = ''
            function(args)
              require('luasnip').lsp_expand(args.body)
            end
          '';
        };
      };

      # lsp
      lsp = {
        capabilities.__raw = ''
           require('cmp_nvim_lsp').default_capabilities()
        '';
        keymaps = {
          diagnostic = {
            "gn" = "goto_next";
            "gp" = "goto_prev";
          };
          lspBuf = {
            K = "hower";
            gD = "references";
            gd = "definition";
            gi = "implementation";
            gt = "type_definition";
          };
        };
        servers = {
          gopls = {
            enable = true;
            filetypes = [
              "go"
            ];
          };

          lua-ls = {
            enable = true;
            filetypes = [ "lua" ];
          };
        };
      };
    };
  };
}
