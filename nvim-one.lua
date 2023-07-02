vim.g.mapleader = " "

vim.opt.termguicolors = true
-- ruller
vim.o.relativenumber = true
vim.o.number = true

vim.opt.cursorline = true
--vim.opt.comments = 'line'
-- Set the behavior of tab
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

vim.opt.smartcase = true
vim.opt.ignorecase = true
vim.opt.hlsearch = false

local plugins = {
    'nvim-tree/nvim-web-devicons',
    {
        'stevearc/oil.nvim',
        config = function()
            require('oil').setup ({})
            vim.keymap.set("n", "-", require("oil").open, { desc = "Open parent directory" })
        end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':lua require("nvim-treesitter.install").update({ with_sync = true })',
        config = function()
            require'nvim-treesitter.configs'.setup {
            ensure_installed = { "markdown", "lua", "python" },
            sync_install = true,
            auto_install = true,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            }
        end
    },
    -- автоматический свитчер layouts
    {
        'lyokha/vim-xkbswitch',
        enabled = true,
        init = function ()
            vim.g.XkbSwitchLib = '/home/qq/Applications/xkb-switch/build/libxkbswitch.so'
            vim.g.XkbSwitchEnabled = 1
        end
    },
    -- вставка картинок в формате md
    -- use 'ferrine/md-img-paste.vim'
    --'ekickx/clipboard-image.nvim',
    {
        'jakewvincent/mkdnflow.nvim',
        ft = { 'markdown' },
        config = function ()
            require('mkdnflow').setup({
            create_dirs = false,
            perspective = {
                priority = 'root',
                fallback = 'current',
                root_tell = 'index.md',
            },
            links = {
                style = 'wiki',
                name_is_source = true,
            },
            mappings = {
                MkdnNextLink = false,
                MkdnPrevLink = false,
                MkdnIncreaseHeading = false,
                MkdnDecreaseHeading = false,
            }
        })
        end
    },
    {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup ({})
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        enabled = true,
        dependencies = { 'nvim-tree/nvim-web-devicons', opt = true },
        config = function()
            require('lualine').setup {
            winbar = {{ 'filename', path = 1, }}
            }
        end
    },
    -- удобно перемещаться по словам
    -- use 'easymotion/vim-easymotion'
    {
        'phaazon/hop.nvim',
        branch = 'v2', -- optional but strongly recommended
        config = function()
            require('hop').setup({ 
            --    keys = 'asdfghjkl',
                quit_key = '<ESC>',
                jump_on_sole_occurrence = false,
                smartcase = true,
                uppercase_labels = false,
            })

            -- keymaps
            vim.keymap.set('n', ',w', ':HopWordMW<CR>', {desc = 'All words in visible buffers'})
            vim.keymap.set('n', ',j', ':HopLineMW<CR>', {desc = 'two way line'})
            vim.keymap.set('n', ',p', ':HopPatternMW<CR>', {desc = 'Pattern in all visible buffers'})
            vim.keymap.set(
                            'n', 
                            '<leader>o', 
                            [[:lua require"hop-custom".hint_wikilink_follow("\\[\\[")<CR>]], 
                            {desc = 'Find all notes [[timestamp]]'}
            )
        end
    },
    { 
        'RRethy/nvim-base16',
        config = function()
            vim.cmd('colorscheme base16-decaf')
        end
    },
    {
        'ibhagwan/fzf-lua',
        -- optional for icon support
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function ()
        require('fzf-lua').setup({'skim'})
        end
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            vim.cmd [[highlight IndentBlanklineIndent1 guifg=#E06C75 gui=nocombine]]
            vim.cmd [[highlight IndentBlanklineIndent2 guifg=#E5C07B gui=nocombine]]
            vim.cmd [[highlight IndentBlanklineIndent3 guifg=#98C379 gui=nocombine]]
            vim.cmd [[highlight IndentBlanklineIndent4 guifg=#56B6C2 gui=nocombine]]
            vim.cmd [[highlight IndentBlanklineIndent5 guifg=#61AFEF gui=nocombine]]
            vim.cmd [[highlight IndentBlanklineIndent6 guifg=#C678DD gui=nocombine]]

            vim.opt.list = true
            vim.opt.listchars:append "space:⋅"
            vim.opt.listchars:append "eol:↴"

            require("indent_blankline").setup {
                space_char_blankline = " ",
                char_highlight_list = {
                    "IndentBlanklineIndent1",
                    "IndentBlanklineIndent2",
                    "IndentBlanklineIndent3",
                    "IndentBlanklineIndent4",
                    "IndentBlanklineIndent5",
                    "IndentBlanklineIndent6",
                },
            }
        end
    },
    {
        'gelguy/wilder.nvim',
        config = function()
            vim.api.nvim_exec([[
            call wilder#setup({
                \ 'modes': [':', '/', '?'],
                \ 'next_key': '<Tab>',
                \ 'previous_key': '<S-Tab>',
                \ })
            ]], false)
        end
    },
    { 'vim-scripts/utl.vim', },
    'Vonr/align.nvim',
    -- Shorthand notation; fetches https://github.com/junegunn/vim-easy-align
    'junegunn/vim-easy-align',
    --completion
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-path',
    'L3MON4D3/LuaSnip',
    'saadparwaiz1/cmp_luasnip',
    'rafamadriz/friendly-snippets',
    {
        'windwp/nvim-autopairs',
        event = "InsertEnter",
        opts = {} -- this is equalent to setup({}) function
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'windwp/nvim-autopairs',
            'hrsh7th/cmp-nvim-lsp',
            'L3MON4D3/LuaSnip',
            'rafamadriz/friendly-snippets',
        },
        config = function()
            local cmp = require('cmp')
            local cmp_autopairs = require('nvim-autopairs.completion.cmp')
            cmp.event:on(
            'confirm_done',
            cmp_autopairs.on_confirm_done()
            )
            require("luasnip.loaders.from_vscode").lazy_load()

            cmp.setup({
                mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-o>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body)
                    end,
                },
                sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                }, {
                { name = 'buffer' },
                { name = 'path' },
                })
            })
        end
    },

    {"nvim-lua/plenary.nvim"},
    -- lsp config
    {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        ft = {
            'python',
            'rust',
            'lua',
        },
        config = function()
            require("mason").setup({
            ensure_installed = {
                "debugpy"
            },
            })
            require("mason-lspconfig").setup {
                ensure_installed = {
                    "lua_ls",
                    "rust_analyzer",
                    "pyright",
                    "sqlls",
                    "bashls",
                    "cssls",
                    "html",
                },
            }

            local opts = { noremap=true, silent=true }
            vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
            vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
            vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
            vim.keymap.set('n', '<space>q', require('fzf-lua').lsp_document_diagnostics, opts)

            local on_attach = function(client, bufnr)
                -- Enable completion triggered by <c-x><c-o>
                vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

                local bufopts = { noremap=true, silent=true, buffer=bufnr }
                vim.keymap.set('n', 'gD',require('fzf-lua').lsp_declarations, bufopts)
                vim.keymap.set('n', 'gs',require('fzf-lua').lsp_document_symbols, bufopts)
                vim.keymap.set('n', 'gd', require('fzf-lua').lsp_definitions, bufopts)
                vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
                vim.keymap.set('n', 'gi', require('fzf-lua').lsp_implementations, bufopts)
                vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
                vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
                vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
                vim.keymap.set('n', '<leader>wl', function()
                    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                    end, bufopts)
                vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
                vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
                vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
                --vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
                vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, bufopts)

                vim.keymap.set("n", "<leader>ca", require('fzf-lua').lsp_code_actions, bufopts)

                vim.keymap.set("n", "gr", require('fzf-lua').lsp_references, bufopts)
            end

            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            require("lspconfig").lua_ls.setup {
                on_attach = on_attach,
                capabilitites = capabilities
            }

            require("lspconfig").pyright.setup {
                on_attach = on_attach,
                capabilitites = capabilities
            }
            require("lspconfig").rust_analyzer.setup {
                on_attach = on_attach,
                capabilitites = capabilities
            }
        end
    },
    --linting
    {'jay-babu/mason-null-ls.nvim'},
    {
        'jose-elias-alvarez/null-ls.nvim',
        ft = { "python", "markdown" },
        dependencies = {
            "nvim-lua/plenary.nvim",
            'jay-babu/mason-null-ls.nvim',
        },
        config = function ()
            require("mason-null-ls").setup({
                ensure_installed = {
                    -- Opt to list sources here, when available in mason.
                    "ruff"
                },
                automatic_installation = false,
                handlers = {},
            })
            local null_ls = require("null-ls")
            null_ls.setup({
                sources = {
                    -- Anything not supported by mason.
                    null_ls.builtins.diagnostics.ltrs
                }
            })
        end
    },
    --dap
    {
        'mfussenegger/nvim-dap',
        lazy = true
    },
    {
        'rcarriga/nvim-dap-ui',
        lazy = true,
        config = function()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
        end,
    },
    {
        'mfussenegger/nvim-dap-python',
        ft = 'python',
        dependencies = {
            'mfussenegger/nvim-dap',
            'rcarriga/nvim-dap-ui',
        },
        config = function ()
            local path_python = '~/.local/share/nvim/mason/packages/debugpy/venv/bin/python'
            require('dap-python').setup(path_python)
        end
    },
    --repl
    {
        "WhiteBlackGoose/magma-nvim-goose",
        enabled = true,
        version = "*",
        --run = 'UpdateRemotePlugins',
        keys = {
            { "<leader>mi", "<cmd>MagmaInit<CR>", desc = "This command initializes a runtime for the current buffer." },
            { "<leader>mo", "<cmd>MagmaEvaluateOperator<CR>", desc = "Evaluate the text given by some operator." },
            { "<leader>ml", "<cmd>MagmaEvaluateLine<CR>", desc = "Evaluate the current line." },
            { "<leader>mv", "<cmd>MagmaEvaluateVisual<CR>", desc = "Evaluate the selected text." },
            { "<leader>mc", "<cmd>MagmaEvaluateOperator<CR>", desc = "Reevaluate the currently selected cell." },
            { "<leader>mr", "<cmd>MagmaRestart!<CR>", desc = "Shuts down and restarts the current kernel." },
            {
                "<leader>mx",
                "<cmd>MagmaInterrupt<CR>",
                desc = "Interrupts the currently running cell and does nothing if not cell is running.",
            },
        },
        config = function ()
            vim.g.magma_image_provider = "none"
            vim.g.magma_automatically_open_output = false

            vim.keymap.set('n', '<leader>rx', "<cmd>lua vim.api.nvim_exec('MagmaEvaluateOperator', true)<cr>", {desc = 'Magma: eval operator'})
            vim.keymap.set('n', '<leader>rl', '<cmd>MagmaEvaluateLine<cr>', {desc = 'Magma: run line'})
            vim.keymap.set('x', '<leader>r', ':<C-u>MagmaEvaluateVisual<cr>', {desc = 'Magma: run visual'})
            vim.keymap.set('n', '<leader>rb', 'vip:<C-u>MagmaEvaluateVisual<cr>', {desc = 'Magma: run current block'})
            vim.keymap.set('n', '<leader>rr', ':MagmaReevaluateCell<cr>', {desc = 'Magma: Re-evaluate cell'})
            vim.keymap.set('n', '<leader>ro', ':MagmaShowOutput<cr>', {desc = 'Magma: Show output'})
            vim.keymap.set('n', '<leader>rq', ':noautocmd MagmaEnterOutput<cr>', {desc = 'Magma: Enter output'})
            --nnoremap <silent> <LocalLeader>rd :MagmaDelete<CR>
        end,
    },
}

local opts = {}

require("lazy").setup(plugins, opts)