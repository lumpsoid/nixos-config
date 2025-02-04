{...}: {
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

    extraConfigLua = ''
      vim.cmd.highlight({"Cursor", "guibg=#5f87af", "ctermbg=67"})
      vim.cmd.highlight({"iCursor", "guibg=#ffffaf", "ctermbg=229"})
      vim.cmd.highlight({"rCursor", "guibg=#d70000", "ctermbg=124"})
      vim.o.guicursor = 'n-v-c:block-Cursor/lCursor,i-ci-ve:ver100-iCursor,r-cr:block-rCursor,o:hor50-Cursor/lCursor,sm:block-iCursor,a:blinkwait1000-blinkon500-blinkoff250'
    '';

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
      "lua/custom_functions.lua".source = ./custom_functions.lua;
      "lua/functions_fzf_lua.lua".source = ./functions_fzf_lua.lua;
      "lua/custom_hop.lua".source = ./hop-custom.lua;
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
        key = "<leader>bc";
        action = "<cmd>bdelete<CR>";
        options = {
          desc = "close current buffer";
          silent = true;
        };
      }
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
        mode = ["n" "v"];
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
      {
        mode = "n";
        key = "<leader>fo";
        action = "<cmd>lua require('functions_fzf_lua').openFile()<CR>";
        options = {
          desc = "fuzzy find and open note";
          silent = true;
        };
      }
      {
        mode = "n";
        key = "<leader>gs";
        action = "<cmd>lua require('fzf-lua').lsp_document_symbols()<CR>";
        options = {
          desc = "lsp document symbols";
          silent = true;
        };
      }
    ];

    files = {
      # example
      #"lua/crdo/init.lua".extraConfigLua = builtins.readFile ./crdo.lua;
      "ftplugin/markdown.lua" = {
        keymaps = [
          {
            mode = ["n" "i"];
            key = "<C-k>";
            action = "<cmd>lua require('functions_fzf_lua').insertId()<CR>";
            options = {
              desc = "for any note [[ID]] insert";
              silent = true;
            };
          }
          {
            mode = ["n" "i"];
            key = "<C-q>";
            action = "<cmd>lua require('functions_fzf_lua').insertHeadId()<CR>";
            options = {
              desc = "tree note [[ID]] insert";
              silent = true;
            };
          }
          {
            mode = "n";
            key = "<leader>nb";
            action = "<cmd>lua require('functions_fzf_lua').backlinks()<cr>";
            options = {
              desc = "find backlinks to open note";
              silent = true;
            };
          }
          # {
          #   mode = ["n"];
          #   key = "<TAB>";
          #   action = "<esc>:lua require('custom_hop').hint_wikilink_follow()<cr>";
          #   options = {
          #     desc = "follow wikilink";
          #     silent = true;
          #   };
          # }
          {
            mode = ["i" "n"];
            key = "<C-y>";
            action = "<esc>:lua require('custom_functions').createID()<cr>jjA";
            options = {
              desc = "create new zettel file";
              silent = true;
            };
          }
          {
            mode = "n";
            key = "<leader>na";
            action = "<cmd>lua require('functions_fzf_lua').findAroundNote()<CR>";
            options = {
              desc = "view notes which was created in the same date as current note";
              silent = true;
            };
          }
          {
            mode = "n";
            key = "<leader>nd";
            action = "<cmd>lua require('custom_functions').delCurrentFile()<CR>";
            options = {
              desc = "delete current file";
              silent = true;
            };
          }
          {
            mode = "n";
            key = "<leader>nc";
            action = "<cmd>lua require('custom_functions').currentLink()<CR>";
            options = {
              desc = "copy link to current file";
              silent = true;
            };
          }
          {
            mode = "n";
            key = "<leader>nl";
            action = "<cmd>lua require('functions_fzf_lua').listOfNotes()<CR>";
            options = {
              desc = "list all notes in reverse order";
              silent = true;
            };
          }
          {
            mode = "n";
            key = "<leader>nf";
            action = "<esc>:MkdnEnter<cr>:lua require('custom_functions').currentLink()<CR>:MkdnGoBack<cr>o<esc>cc- <c-r>+<esc>kdd";
            options = {
              desc = "change just ID to H1 ID";
              silent = true;
            };
          }
          {
            mode = "n";
            key = "gh";
            action = "<esc>:e index.md<CR>";
            options = {
              desc = "go home";
              silent = true;
            };
          }
          {
            mode = "n";
            key = "<leader>jt";
            action = "<cmd>lua require('custom_functions').openJournal()<CR>";
            options = {
              desc = "open journal today";
              silent = true;
            };
          }
        ];
      };
    };

    plugins = {
      web-devicons.enable = true;
      bufferline = {
        enable = true;
      };

      nvim-autopairs.enable = true;

      indent-blankline.enable = true;

      oil = {
        enable = true;
        settings = {
          view_options = {
            show_hidden = true;
          };
        };
      };

      hop = {
        enable = true;
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
          {paths = ../vscode/snippets;}
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
          diagnostic = {
            "<leader>e" = "open_float";
            "gn" = "goto_next";
            "gp" = "goto_prev";
          };
          lspBuf = {
            "K" = "hover";
            "gD" = "references";
            "gd" = "definition";
            "gi" = "implementation";
            "gt" = "type_definition";
            "gr" = "rename";
            "<leader>cf" = "format";
            "<leader>ca" = "code_action";
          };
        };
        servers = {
          harper_ls = {
            enable = true;

            settings = {
              "harper-ls" = {
                linters = {
                  sentence_capitalization = false;
                };
              };
            };
          };

          gopls = {
            enable = true;
            filetypes = ["go"];
          };

          lua_ls = {
            enable = true;
            filetypes = ["lua"];
          };

          bashls = {
            enable = true;
            filetypes = ["bash" "sh"];
          };

          dartls = {
            enable = true;
            filetypes = ["dart"];
          };

          ts_ls = {
            enable = true;
            filetypes = ["javascript" "typescript"];
          };
          nixd = {
            enable = true;
            settings.formatting.command = ["alejandra"];
          };
          elixirls = {
            enable = true;
          };
          rust_analyzer.enable = true;
        };
      };
    };
  };
}
