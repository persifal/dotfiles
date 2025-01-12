local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local packer_bootstrap = false

if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    packer_bootstrap = true
    vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
    vim.cmd [[packadd packer.nvim]]
end


require('packer').startup(function(use)
    -- Itself
    use { 'wbthomason/packer.nvim' }
    use { 'folke/neodev.nvim' }

    -- LSP
    use {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        'neovim/nvim-lspconfig',
        requires = {
            'folke/neodev.nvim',
        },
    }

    -- DAP ui
    use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } }
    use { 'leoluz/nvim-dap-go' }

    -- Style
    use { 'nvim-tree/nvim-tree.lua', requires = 'nvim-tree/nvim-web-devicons' }
    use { 'rebelot/kanagawa.nvim' }
    use { 'hoob3rt/lualine.nvim', requires = 'nvim-tree/nvim-web-devicons' }
    use { 'akinsho/bufferline.nvim', requires = 'nvim-tree/nvim-web-devicons' }

    -- highlight references under cursor
    use { 'RRethy/vim-illuminate' }

    -- Treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            pcall(require('nvim-treesitter.install').update { with_sync = true })
        end,
    }
    use {
        'nvim-treesitter/nvim-treesitter-textobjects',
        after = 'nvim-treesitter'
    }

    -- Autocompletion
    use {
        'hrsh7th/nvim-cmp',
        requires = { 'hrsh7th/cmp-nvim-lsp', 'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip' },
    }

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    -- AI
    use {
        'olimorris/codecompanion.nvim',
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    }

    use {
        'MeanderingProgrammer/render-markdown.nvim',
        after = { 'nvim-treesitter' },
        requires = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
        },
        config = function()
            require('render-markdown').setup({
                filetypes = { 'markdown', 'codecompanion' },
            })
        end,
    }

    -- Misc
    -- "gc" to comment visual regions/lines
    use { 'numToStr/Comment.nvim' }
    -- Autopairs
    use { 'windwp/nvim-autopairs' }

    if packer_bootstrap then
        require('packer').sync()
    end
end)

if packer_bootstrap then
    print 'Installing plugins...'
    return
end

local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
    command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
    group = packer_group,
    pattern = vim.fn.expand '$MYVIMRC'
})
