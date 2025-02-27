local opt = vim.opt

-- Editor options
local options = {
    wrap = false,
    relativenumber = true,
    showmode = false,
    mouse = 'a',
    signcolumn = 'number',
    syntax = 'enabled',
    hlsearch = false,
    incsearch = true,
    ignorecase = true,
    hidden = true,
    expandtab = true,
    smartindent = true,
    tabstop = 4,
    shiftwidth = 4,
    softtabstop = 4,
    termguicolors = true,
    updatetime = 300,
    shortmess = 'filnxtToOFc'
}

for k, v in pairs(options) do
    opt[k] = v
end
