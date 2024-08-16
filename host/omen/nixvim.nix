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

    keymaps = [
      {
        mode = "n";
        key = "-";
        action = "<cmd>Oil<CR>";
        options = {
          desc = "open file manager oil";
          silent = true;
        };
      }      
      {
        mode = "n";
        key = "<leader>y";
        action = ''"+yy'';
        options = {
          desc = "copy to the clipboard normal";
          silent = true;
        };
      }      
      {
        mode = "v";
        key = "<leader>y";
        action = ''"+y'';
        options = {
          desc = "copy to the clipboard visual";
          silent = true;
        };
      }      
      {
        mode = [ "n" "v" ];
        key = "<leader>p";
        action = ''"+p'';
        options = {
          desc = "past from the clipboard";
          silent = true;
        };
      }      
      {
        mode = "n";
        key = "<leader>sv";
        action = "<cmd>vs<CR><c-w>w<CR>";
        options = {
          desc = "splite tab vertically and focus on it";
          silent = true;
        };
      }      
      {
        mode = "n";
        key = "<leader>sh";
        action = "<cmd>sp<CR><c-w>w<CR>";
        options = {
          desc = "splite tab horizontally and focus on it";
          silent = true;
        };
      }      
    ];

    files = {
      "ftplugin/markdown.lua" = {
        keymaps = [
          {
            mode = "n";
            key = "<leader>gh";
            action = "<cmd>e index.md<CR>";
            options = {
              desc = "go home";
              silent = true;
            };
          }      
        ];
      };
    };

    plugins = {

      bufferline = {
        enable = true;
      };

      nvim-autopairs.enable = true;

      indent-blankline.enable = true;

      oil= {
        enable = true;
        settings = {
          view_options = {
            show_hidden = true;
          };
        };
      };

      mkdnflow = {
        enable = true;
        createDirs = false;
        wrap = true;
        perspective = {
          priority = "root";
          fallback = "current";
          rootTell = "index.md";
        };
        links = {
          style = "wiki";
        };
        mappings = {
          MkdnNextLink = false;
          MkdnPrevLink = false;
          MkdnIncreaseHeading = false;
          MkdnDecreaseHeading = false;
          MkdnNewListItem = false;
          MkdnNewListItemAboveInsert = false;
          MkdnNewListItemBelowInsert = false;
        };
        modules = {
          bib = false;
        };
        extraOptions = {
          "name_is_source" = true;
        };
      };

      fzf-lua = {
        enable = true;
        keymaps = {
          "<leader>sf" = {
            action = "files";
            options = {
              desc = "fzf search filenames";
              silent = true;
            };
          };
          "<leader>sb" = {
            action = "buffers";
            options = {
              desc = "fzf search buffers";
              silent = true;
            };
          };
          "<leader>h" = {
            action = "oldfiles";
            options = {
              desc = "open history pane";
              silent = true;
            };
          };
        };
      };

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
