local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--branch=stable",
        lazyrepo,
        lazypath
    })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out,                            "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end

vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
    -- Core
    { 'folke/neodev.nvim' },

    -- LSP
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "folke/neodev.nvim",
        },
    },

    -- DAP
    {
        "rcarriga/nvim-dap-ui",
        dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" }
    },
    { 'leoluz/nvim-dap-go' },

    -- Style
    {
        'nvim-tree/nvim-tree.lua',
        dependencies = { 'nvim-tree/nvim-web-devicons' }
    },
    {
        'cocopon/iceberg.vim',
        lazy = false,
        priority = 1000,
        config = function()
            -- require('iceberg').setup()
            vim.cmd("colorscheme iceberg")
        end,
    },
    { 'hoob3rt/lualine.nvim',    dependencies = { 'nvim-tree/nvim-web-devicons' } },
    { 'akinsho/bufferline.nvim', dependencies = { 'nvim-tree/nvim-web-devicons' } },

    -- Highlighting
    { 'RRethy/vim-illuminate' },

    -- Treesitter
    {
        'nvim-treesitter/nvim-treesitter',
        build = ":TSUpdate",
    },
    {
        'nvim-treesitter/nvim-treesitter-textobjects',
        dependencies = { "nvim-treesitter/nvim-treesitter" }
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip"
        },
    },

    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        tag = "0.1.4",
        dependencies = { "nvim-lua/plenary.nvim" }
    },

    -- AI
    {
        'olimorris/codecompanion.nvim',
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },

    },
    {
        'MeanderingProgrammer/render-markdown.nvim',
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },

        config = function()
            require('render-markdown').setup({
                filetypes = { 'markdown', 'codecompanion' },
            })
        end,
    },

    -- Misc
    { 'numToStr/Comment.nvim' },
    { 'windwp/nvim-autopairs' },
})
