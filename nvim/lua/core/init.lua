local M = {}

require('core.options')
require('core.keymaps')
require('core.autocmds')

vim.g.mapleader = '\\'
vim.cmd('colorscheme kanagawa')
vim.cmd('hi Comment guifg=#637777 ctermfg=243 gui=None cterm=None')
vim.cmd('filetype plugin indent on')

-- WSL clipboard support
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

return M
