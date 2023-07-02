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

vim.g.XkbSwitchLib = '/home/qq/Applications/xkb-switch/build/libxkbswitch.so'
vim.g.XkbSwitchEnabled = 1
vim.api.nvim_create_autocmd("FileType", {
    pattern = "markdown", 
    callback = function()
       vim.cmd([[
           set awa
           set com=b:-,n:>
           set formatoptions+=ro
       ]])
       --vim.opt.listchars:append({space = '|'})
    end
})
require('lualine').setup({ winbar = { lualine_c = { { 'filename', path = 1, } } } })
require('oil').setup({})
require("nvim-autopairs").setup({})
require('nvim-treesitter.configs').setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false
  }
})

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
require("which-key").setup ({})
require("which-key").register(
    {
        ["-"] = {"<cmd>Oil<CR>", "Open parent directory"},
        ["<leader>"] = {
            o = {[[:lua require"hop-custom".hint_wikilink_follow("\\[\\[")<CR>]], "Find all notes [[timestamp]]"},
        },
        [","] = {
            w = {"<cmd>HopWordMW<CR>", "All words in visible buffers"},
            j = {"<cmd>HopLineMW<CR>", "two way line"},
            p = {"<cmd>HopPatternMW<CR>", "Pattern in all visible buffers"},
        },
    },
    { mode = "n" }
)
vim.keymap.set('n', '<Leader>set', ':tabnew $MYVIMRC<CR>', {desc = 'open MYVIMRC'})
-- Mappings
vim.keymap.set('n', '<c-s>', ':wa<cr>', {desc = 'Save file'})
vim.keymap.set({'n', 'v'}, '<Leader>y', '"+y', {desc = 'Save to global clipboard'})
vim.keymap.set('n', '<Leader>p', '"+p', {desc = 'Past from global clipboard'})
--tabs
vim.keymap.set('n', '<leader>tn', ':tabnew<CR>', {desc = 'new tab'})
vim.keymap.set('n', '<leader>vs', ':vs<CR><c-w>w', {desc = 'open new split window and focus on it'})
vim.keymap.set('n', '<leader>tc', ':clo<CR>', {desc = 'close current tab'})
--something
vim.keymap.set('n', 'i', 'zzi', {desc = 'center screen when entering insert mode'})

vim.keymap.set('n', '<leader>fo', '<cmd>lua require("core.custom_fzf_lua").openFile()<CR>', {desc = 'find and open note through telescope'})
vim.keymap.set('n', '<leader>h', '<cmd>FzfLua oldfiles<CR>', {desc = 'open history pane'})
vim.keymap.set('n', '<leader>bl', '<cmd>lua require("fzf-lua").blines()<CR>', {desc = 'поиск по открытым buffers'})
--complition
vim.keymap.set('n', '<leader>sn', '<cmd>lua require("luasnip").jump(1)<Cr>', {desc = 'next snippet placeholder'})
vim.keymap.set('n', '<leader>sp', '<cmd>lua require("luasnip").jump(-1)<Cr>', {desc = 'previous snippet placeholder'})
require('hop').setup({ 
      quit_key = '<ESC>',
      jump_on_sole_occurrence = false,
      smartcase = true,
      uppercase_labels = false,
  })

  -- keymaps
vim.cmd.colorscheme('base16-decaf')
require('fzf-lua').setup({'skim'})
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
vim.api.nvim_exec([[
  call wilder#setup({
    \ 'modes': [':', '/', '?'],
    \ 'next_key': '<Tab>',
    \ 'previous_key': '<S-Tab>',
    \ })
]], false)

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
require("mason").setup({ ensure_installed = { "debugpy" },
})
require("mason-lspconfig").setup {
  ensure_installed = {
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
--require("mason-null-ls").setup({
--    ensure_installed = {
--        -- Opt to list sources here, when available in mason.
--        "ruff"
--    },
--    automatic_installation = false,
--    handlers = {},
--})
local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        -- Anything not supported by mason.
       -- null_ls.builtins.diagnostics.ltrs
    }
})
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

local path_python = '~/.local/share/nvim/mason/packages/debugpy/venv/bin/python'
require('dap-python').setup(path_python)
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
--{ "<leader>mi", "<cmd>MagmaInit<CR>", desc = "This command initializes a runtime for the current buffer." },
--        { "<leader>mo", "<cmd>MagmaEvaluateOperator<CR>", desc = "Evaluate the text given by some operator." },
--        { "<leader>ml", "<cmd>MagmaEvaluateLine<CR>", desc = "Evaluate the current line." },
--        { "<leader>mv", "<cmd>MagmaEvaluateVisual<CR>", desc = "Evaluate the selected text." },
--        { "<leader>mc", "<cmd>MagmaEvaluateOperator<CR>", desc = "Reevaluate the currently selected cell." },
--        { "<leader>mr", "<cmd>MagmaRestart!<CR>", desc = "Shuts down and restarts the current kernel." },
--        {
--            "<leader>mx",
--            "<cmd>MagmaInterrupt<CR>",
--            desc = "Interrupts the currently running cell and does nothing if not cell is running.",
--        },
--{'jay-babu/mason-null-ls.nvim'},
local mkdn = require('mkdnflow')

local M = {}

function M.resethl()
    vim.cmd[[let @/='']]
end

function M.sleep(n)
  os.execute("sleep " .. tonumber(n))
end

function M.sleep_sec(a)
    local sec = tonumber(os.clock() + a);
    while (os.clock() < sec) do
    end
end

function M.textinsert(text)
  local pos = vim.api.nvim_win_get_cursor(0)[2]
  local line = vim.api.nvim_get_current_line()
  local nline = line:sub(1, pos + 1) .. text .. line:sub(pos + 2)
  vim.api.nvim_set_current_line(nline)
end

function M.ztltime()
    return os.date("%Y%m%d%H%M%S")
end

function M.linkwrap(text)
    return '[['..text..']]'
end

local function noteTemplate()
    text = [[
        # title
        tags: #
        - 
    ]]
    return text
end

function M.writefile(path, text)
    filewrite = io.open(path, "w")
    filewrite:write(text)
    filewrite:close()
end

function M.cleanline(line)
    local line = line:gsub(' *- ','')
    line = line:gsub('%s*$','')
    return line
end

function M.cleanHeadline(line)
    local line = line:gsub('# ','')
    line = line:gsub('%s*$','')
    return line
end

function M.currentNoteId()
    local path_to_file = vim.api.nvim_buf_get_name(0)
    local id = vim.fn.fnamemodify(path_to_file, ":t:r")
    return id
end

function M.backlinks()
    vim.fn.setreg('"', "'"..M.currentNoteId())
end

function M.aroundNote()
    local note = M.currentNoteId():sub(1,8) .. "*"
    vim.fn.setreg('+', note)
    return note
end

function M.delCurrentFile()
    vim.ui.select({ 'yes', 'no' }, {
    prompt = 'Select Yes or No:',
    }, function(choice)
        if choice == 'yes' then
            vim.cmd[[call delete(expand('%')) | bdelete!]]
        end
    end)
end

function M.currentLink()
    local path_to_file = vim.api.nvim_buf_get_name(0)
    local id = vim.fn.fnamemodify(path_to_file, ":t:r")
    -- Opens a file in read mode
    local file = io.open(path_to_file, "r")
    -- prints the first line of the file
    local header = file:read()
    -- closes the opened file
    file:close()
    local link = M.cleanHeadline(header):lower() .. " [[" .. id .. "]]"
    vim.fn.setreg('+', link)
    return link
end

local note_template = "\ntag: N\n- "

function M.createID()
    local main_note = M.currentLink()
    local ztl = M.ztltime()
    -- dynamicly take current folder to create note in it
    local current_folder = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(0), ":h")
    local file_path = current_folder .. '/' .. ztl .. ".md"
    local new_header = vim.api.nvim_get_current_line()
    new_header = M.cleanline(new_header)
    local text = '# ' .. new_header .. note_template .. '\n\n' .. main_note
    -- можно использовать для этого nvim.api.nvim_put()
    M.writefile(file_path, text)
    M.textinsert(M.linkwrap(ztl))
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_win_set_cursor(0, {pos[1],pos[2]+1})
    mkdn.links.followLink()
end

function M.backlinks()
    local note = require("core.custom_functions").currentNoteId()
    require('fzf-lua').grep({
      search = note,
      fzf_cli_args = '--preview-window=~1',
      previewer = 'bat',
      keymap = {
          fzf = {
              ["shift-down"] = "preview-half-page-down",
              ["shift-up"] = "preview-half-page-up",
          }
      },
      winopts = {
          preview = {
              horizontal = 'down:60%'
          }
      },
    })
end

function M.findAroundNote()
    local current_note = require("core.custom_functions").aroundNote()
    require('fzf-lua').files({
        cmd = "ls" .. " " .. current_note,
        fzf_cli_args = '--preview-window=~1',
        previewer = 'bat',
        keymap = {
            fzf = {
                ["shift-down"] = "preview-half-page-down",
                ["shift-up"] = "preview-half-page-up",
            }
        },
        winopts = {
            preview = {
                horizontal = 'down:60%'
            }
        },
})
end

function M.listOfNotes()
    require('fzf-lua').files({
        cmd = "rg --files -g *.md --sortr=path",
        fzf_cli_args = '--preview-window=~1',
        previewer = 'bat',
        keymap = {
            fzf = {
                ["shift-down"] = "preview-half-page-down",
                ["shift-up"] = "preview-half-page-up",
            }
        },
        winopts = {
            preview = {
                horizontal = 'down:60%'
            }
        },
})
end

function M.insertHeadId()
    require('fzf-lua').grep({
      search = '',
      fzf_cli_args = '--preview-window=~1',
      previewer = 'bat',
      keymap = {
          fzf = {
              ["shift-down"] = "preview-half-page-down",
              ["shift-up"] = "preview-half-page-up",
          }
      },
      winopts = {
          preview = {
              horizontal = 'down:60%'
          }
      },
      actions = {
        ['default'] = function(selected, opts)
            local cwd = vim.loop.cwd()
            local file_md = string.match(selected[1], "[0-9]+%a*.md")

            local path_to_file = cwd .. "/" .. file_md
            local file = io.open(path_to_file, "r")
            local header = file:read()
            file:close()

            local ztl_id = "[[" .. file_md:sub(1,14) .. "]]"

            local output = require("core.custom_functions").cleanHeadline(header):lower() .. " " .. ztl_id
            vim.api.nvim_put({ output }, "", true, true)
          end
      }
    })
end

function M.insertId()
    require('fzf-lua').grep({
      search = '',
      fzf_cli_args = '--preview-window=~1',
      previewer = 'bat',
      keymap = {
          fzf = {
              ["shift-down"] = "preview-half-page-down",
              ["shift-up"] = "preview-half-page-up",
          }
      },
      winopts = {
          preview = {
              horizontal = 'down:60%'
          }
      },
      actions = {
        ['default'] = function(selected)
            local file_md = string.match(selected[1], "[0-9]+%.md")
            local ztl_id = "[[" .. file_md:sub(1,14) .. "]]"
            vim.api.nvim_put({ ztl_id }, "", true, true)
          end
      }
    })
end

function M.openFile()
    require('fzf-lua').grep({
      search = '',
      fzf_cli_args = '--preview-window=~1',
      previewer = 'bat',
      keymap = {
          fzf = {
              ["shift-down"] = "preview-half-page-down",
              ["shift-up"] = "preview-half-page-up",
          }
      },
      winopts = {
          preview = {
              horizontal = 'down:60%'
          }
      },
    })
end
local hop = require('hop')
local jump_target = require'hop.jump_target'
local mkdnflow_links = require('mkdnflow.links')

function M.hint_wikilink_follow(pattern)
  local opts = {
    keys = 'asdghklqwertyuiopzxcvbnmfj',
    quit_key = '<Esc>',
    perm_method = require'hop.perm'.TrieBacktrackFilling,
    reverse_distribution = false,
    teasing = true,
    jump_on_sole_occurrence = true,
    case_insensitive = true,
    create_hl_autocmd = true,
    current_line_only = false,
    uppercase_labels = false,
    multi_windows = true,
    hint_position = require'hop.hint'.HintPosition.BEGIN,
    hint_offset = 0
  }

  local generator
  generator = jump_target.jump_targets_by_scanning_lines

  hop.hint_with_callback(
    generator(jump_target.regex_by_case_searching(pattern, false, opts)),
    opts,
    function(jt)
        hop.move_cursor_to(jt.window, jt.line + 1, jt.column - 1, opts.hint_offset, opts.direction)
        mkdnflow_links.followLink()
    end
  )
end

return M
