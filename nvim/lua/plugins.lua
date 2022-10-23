local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

return require('packer').startup(function()

    -- Itself
    use { 'wbthomason/packer.nvim' }

    -- Style
    use { 'haishanh/night-owl.vim' }
    use { 'hoob3rt/lualine.nvim', requires = 'kyazdani42/nvim-web-devicons' }

    -- CoC
    use { 'neoclide/coc.nvim', branch = 'release' }
    -- Telescope
    use { 'nvim-telescope/telescope.nvim', tag = '0.1.0', requires = {{ 'nvim-lua/plenary.nvim' }} }
    -- Markdown
    use { 'iamcco/markdown-preview.nvim' }
    -- File explorer
    use { 'kyazdani42/nvim-tree.lua', requires = 'kyazdani42/nvim-web-devicons' }
    use { 'nvim-treesitter/nvim-treesitter'}
    -- OrgMode
    use { 'nvim-neorg/neorg', run = ':Neorg sync-parsers', tag = '0.0.15', requires = 'nvim-lua/plenary.nvim' }

    -- Automatically set up configuration after cloning packer.nvim
    if packer_bootstrap then
      require('packer').sync()
    end
end)


