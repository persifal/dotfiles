local map = vim.keymap.set
local mapOpts = { noremap = true, silent = true }
local function nm(key, command)
    map('n', key, command, mapOpts)
end

local function im(key, command)
    map('i', key, command, mapOpts)
end

local function tm(key, command)
    map('t', key, command, mapOpts)
end

-- File explorer
nm('<leader>r', ':NvimTreeRefresh<CR>')
nm('<leader>n', ':NvimTreeFindFile<CR>')
nm('<M-1>', ':NvimTreeToggle<CR>')


-- Buffer navigation
nm('<C-n>', ':tabnew<CR>')
nm('<C-h>', ':bprevious<CR>')
nm('<C-Left>', ':bprevious<CR>')
nm('<C-l>', ':bnext<CR>')
nm('<C-Right>', ':bnext<CR>')
nm('<M-w>', ':bd<CR>')

-- Window navigation
nm('<A-h>', '<C-w>h')
nm('<A-j>', '<C-w>j')
nm('<A-k>', '<C-w>k')
nm('<A-l>', '<C-w>l')

-- Cursor navigation
nm('<C-M-left>', '<C-O>')
nm('<C-M-right>', '<C-I>')

-- Editing
nm('<S-U>', ':redo<CR>')
nm('<C-M-l>', ':Format<CR>:w<CR>')

-- Disable keys
nm('<PageDown>', '<Nop>')
nm('<PageUp>', '<Nop>')
im('<PageDown>', '<Nop>')
im('<PageUp>', '<Nop>')

-- Terminal
tm('<Esc>', '<C-\\><C-n>')

-- Diagnostic navigation
nm('[d', vim.diagnostic.goto_prev)
nm(']d', vim.diagnostic.goto_next)

-- Telescope mappings
local ok, telescope = pcall(require, "telescope.builtin")
if not ok then
    return
end
map('n', '<leader>ff', telescope.find_files, {})
map('n', '<leader>fg', telescope.current_buffer_fuzzy_find, {})
map('n', '<leader>fb', telescope.buffers, {})
map('n', '<leader>fh', telescope.help_tags, {})
map('n', '<M-CR>', telescope.quickfix, {})

-- Debug mappings
local dap = require('dap')
map('n', '<F12>', dap.continue, {})
map('n', '<F7>', dap.step_into, {})
map('n', '<F8>', dap.step_over, {})
map('n', '<F2>', dap.terminate, {})
map('n', '<leader>cb', dap.clear_breakpoints, {})
map('n', '<leader>b', dap.toggle_breakpoint, {})

-- Comment
im('<C-_>', '<Esc>gcc^i')
