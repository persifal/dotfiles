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
        theme = 'iceberg_dark',
        icons_enabled = true,
        component_separators = ' ',
        section_separators = '',
    }
}

-- Comment
require('Comment').setup()

-- Telescope
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
require('nvim-treesitter.configs').setup {
    ensure_installed = { 'go', 'lua', 'python', 'vim', "markdown", "markdown_inline" },

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
            lookahead = true,
            keymaps = {
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

-- Mason
require("mason").setup()
require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls", "gopls" }
}

-- Neodev
require('neodev').setup {
    library = {
        plugins = { "nvim-dap-ui" },
        types = true,
    },
}

-- Autocompletion
local cmp = require('cmp')
local luasnip = require('luasnip')
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
        { name = 'codecompanion' },
        { name = 'render-markdown' },
    }, {
        { name = 'buffer' }
    })
}

-- AI
local ai_proxy = os.getenv("ANTHROPIC_PROXY")
require('codecompanion').setup {
    display = {
        chat = {
            window = {
                position = "right",
                width = 0.3,
            },
            intro_message = "Prompt... Press ? for options",
        },
        action_palette = {
            provider = 'telescope',
        },
    },
    strategies = {
        chat = {
            adapter = "anthropic",
        },
        inline = {
            adapter = "anthropic",
        },
        cmd = {
            adapter = "anthropic",
        }
    },
    adapters = {
        opts = {
            allow_insecure = false,
            proxy = ai_proxy,
        },
        anthropic = function()
            return require("codecompanion.adapters").extend("anthropic", {
                env = {
                    api_key = "ANTHROPIC_API_KEY",
                },
            })
        end,
    },
}

-- Debug
require("dapui").setup()
require('dap-go').setup()
