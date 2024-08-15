{
  pkgs,
  config,
  ...
}: {
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
      #relativenumber = true;
    };

    autoCmd = [
      {
        event = "FileType";
        pattern = "markdown";
        callback = {
          __raw = ''
            function()
              vim.cmd([[
                set awa
                set com=b:-,n:>
                set formatoptions+=ro
              ]])
            end
          '';
        };
      }
      {
        # as example for future
        event = ["BufWritePost"];
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

      treesitter = {
        enable = true;
        settings = {
          auto_install = true;
          ensure_installed = [
            "markdown"
            "lua"
            "go"
            "dart"
          ];
          indent = {
            enable = true;
          };
          highlight = { 
            enable = true;
            additional_vim_regex_highlighting = false;
          };
        };
      };

      # completion
      cmp-nvim-lsp.enable = true;
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
          mapping = {
            "<Tab>" = "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
            "<C-j>" = "cmp.mapping.select_next_item()";
            "<C-k>" = "cmp.mapping.select_prev_item()";
            "<C-e>" = "cmp.mapping.abort()";
            "<C-b>" = "cmp.mapping.scroll_docs(-4)";
            "<C-f>" = "cmp.mapping.scroll_docs(4)";
            "<C-Space>" = "cmp.mapping.complete()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<S-CR>" = "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
          };
        };
      };

      # lsp
      lsp = {
        enable = true;

        keymaps = {
          #diagnostic = {
          #  "gn" = "goto_next";
          #  "gp" = "goto_prev";
          #};
          lspBuf = {
            "K" = "hover";
            "gD" = "references";
            "gd" = "definition";
            "gi" = "implementation";
            "gt" = "type_definition";
          };
        };
        servers = {
          gopls = {
            enable = true;
            filetypes = [ "go" ];
          };

          lua-ls = {
            enable = true;
            filetypes = ["lua"];
          };

          dartls = {
            enable = true;
            filetypes = ["dart"];
          };

          tsserver = {
            enable = true;
            filetypes = [ "js" "ts" ];
          };
        };
      };
    };
  };
}
