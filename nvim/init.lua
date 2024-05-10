vim.g.mapleader = '\\'

local opt = vim.opt

-- Copy/Paste for windows wsl
opt.clipboard = "unnamedplus"
if vim.fn.has('wsl') == 1 then
    vim.g.clipboard = {
        name = 'WslClipboard',
        copy = {
            ['+'] = 'clip.exe',
            ['*'] = 'clip.exe',
        },
        paste = {
            ['+'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
            ['*'] = 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
        },
        cache_enabled = 0,
    }
end

opt.wrap = false
opt.relativenumber = true
opt.showmode = false
opt.mouse = 'a'
opt.signcolumn = 'number'
opt.syntax = 'enabled'
opt.hlsearch = true
opt.incsearch = true
opt.ignorecase = true
opt.hidden = true
opt.expandtab = true
opt.smartindent = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.termguicolors = true
opt.updatetime = 300
opt.shortmess = 'filnxtToOFc'

-- load plugins
require('plugins')

local cmd = vim.cmd
cmd('colorscheme kanagawa')
cmd('hi Comment guifg=#637777 ctermfg=243 gui=None cterm=None')
cmd('filetype plugin indent on')

local map = vim.api.nvim_set_keymap
local function nm(key, command)
    map('n', key, command, { noremap = true })
end

local function tm(key, command)
    map('t', key, command, { noremap = true })
end

local function im(key, command)
    map('i', key, command, { noremap = true })
end

-- File explorer navigation
-- refresh tree
nm('<leader>r', ':NvimTreeRefresh<CR>')
-- find file in tree
nm('<leader>n', ':NvimTreeFindFile<CR>')
-- toggle navigation tree
nm('<leader>e', ':NvimTreeToggle<CR>')

-- Buffers navigation
-- new buffer
nm('<C-n>', ':tabnew<CR>')
-- left
nm('<C-h>', ':bprevious<CR>')
nm('<C-Left>', ':bprevious<CR>')
-- right
nm('<C-l>', ':bnext<CR>')
nm('<C-Right>', ':bnext<CR>')
-- close
nm('<M-w>', ':bd<CR>')

-- Buffers jumping
nm('<A-h>', '<C-w>h')
nm('<A-j>', '<C-w>j')
nm('<A-k>', '<C-w>k')
nm('<A-l>', '<C-w>l')
-- Cursor position back
nm('<C-M-left>', '<C-O>')
-- Cursor position forward
nm('<C-M-right>', '<C-I>')

-- Redo
nm('<S-U>', ':redo<CR>')

-- Disabled keys
nm('<PageDown>', '<Nop>')
nm('<PageUp>', '<Nop>')
im('<PageDown>', '<Nop>')
im('<PageUp>', '<Nop>')
-- nm('/', '<Nop>')

-- Refactoring
-- Format + save
nm('<C-M-l>', ':Format<CR>:w<CR>')

-- Diagnostic keymaps
nm('[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>')
nm(']d', '<cmd>lua vim.diagnostic.goto_next()<CR>')

tm('<Esc>', '<C-\\><C-n>')

-- Bufferline
require("bufferline").setup {
    highlights = {
        buffer_selected = {
            italic = false
        }
    }
}

-- Autopairs
require('nvim-autopairs').setup {}

-- Lualine
require('lualine').setup {
    options = {
        theme = 'everforest',
        icons_enabled = true,
        component_separators = ' ',
        section_separators = '',
    }
}

-- Comment
require('Comment').setup()

-- Telescope
    local builtin = require('telescope.builtin')
    vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
    vim.keymap.set('n', '<leader>fg', builtin.current_buffer_fuzzy_find, {})
    vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
    vim.keymap.set('n', '<M-cr>', builtin.quickfix, {})
    require('telescope').setup {
        defaults = {
            mappings = {
                i = {
                    ['<c-u>'] = false,
                    ['<c-d>'] = false,
                },
            },
        },
    }

-- Treesitter
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
    -- Add languages to be installed here that you want installed for treesitter
    ensure_installed = { 'go', 'lua', 'python', 'help', 'vim' },

    highlight = { enable = true },
    indent = { enable = true, disable = { 'python' } },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<M-Up>',
            node_incremental = '<M-Up>',
            node_decremental = '<M-Down>',
        },
    },
    textobjects = {
        select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
            },
        },
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer',
            },
            goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer',
            },
            goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer',
            },
            goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer',
            },
        },
    },
}

--- Nvim-tree
require('nvim-tree').setup {
    respect_buf_cwd = true,
    disable_netrw = true,
    sort_by = "name",
    renderer = {
        highlight_git = true,
        special_files = { 'README.md', 'Makefile', 'MAKEFILE', 'Dockerfile' },
        highlight_opened_files = 'icon',
        group_empty = true,
        indent_width = 3,
        indent_markers = {
            enable = true,
        },
        icons = {
            show = {
                git = false,
                folder_arrow = false,
            },
        },
    },
}

-- LSP settings.
-- This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('<leader>td', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- See `:help K` for why this keymap
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

    -- Lesser used LSP functionality
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
    nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
    nmap('<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, '[W]orkspace [L]ist Folders')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })

    -- Disable inline error displaying
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        {
            virtual_text = false,
            signs = true,
            update_in_insert = false,
            underline = true,
        }
    )
end

local lspconfig = require 'lspconfig'
lspconfig.gopls.setup {
    on_attach = on_attach,
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
            },
            staticcheck = true,
            gofumpt = true,
        }
    },
 }

require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls", "gopls" }
}

      -- autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
      -- autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
      -- autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = "*.go",
  callback = function()
    local params = vim.lsp.util.make_range_params()
    params.context = {only = {"source.organizeImports"}}
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
    vim.lsp.buf.format({async = false})
  end
})

require("dapui").setup()
require('dap-go').setup()
local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
vim.fn.sign_define('DapBreakpoint',{ text ='🟥', texthl ='', linehl ='', numhl =''})
vim.fn.sign_define('DapStopped',{ text ='▶️', texthl ='', linehl ='', numhl =''})
local dap_debug = require 'dap'
vim.keymap.set('n', '<F12>', dap_debug.continue)
vim.keymap.set('n', '<F7>', dap_debug.step_into)
vim.keymap.set('n', '<F8>', dap_debug.step_over)
vim.keymap.set('n', '<F2>', dap_debug.terminate)
vim.keymap.set('n', '<leader>cb', dap_debug.clear_breakpoints)
vim.keymap.set('n', '<leader>b', dap_debug.toggle_breakpoint)


require('neodev').setup {
    library = { plugins = { "nvim-dap-ui" }, types = true },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- nvim-cmp setup
local cmp = require 'cmp'
local luasnip = require 'luasnip'
cmp.setup {
    completion = {
        keyword_length = 0,
        autocomplete = false,
    },
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
        }
    },
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' }
    })
}
