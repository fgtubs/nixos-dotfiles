--remap- Set space as the mapleader
vim.g.mapleader = " "

-- Map the escape for changing to normal mode to kj 
vim.api.nvim_set_keymap('i', 'kj', '<Esc>', { noremap = true, silent = true })

-- Define the mapping for <Leader>t to open a new tab
vim.api.nvim_set_keymap('n', '<Leader>tab', ':tabnew<CR>', { noremap = true, silent = true })

-- Mapping for pasting from system clipboard if in normal mode
vim.api.nvim_set_keymap('n', '<C-v>', '"+p', { noremap = true, silent = true })

-- Mapping for pasting from system clipboard, if in insert mode
vim.api.nvim_set_keymap('i', '<C-v>', '<C-r>+', { noremap = true, silent = true })

-- Mapping for the listen-cmd to Ctrl-l (for listen)
vim.api.nvim_set_keymap('i', '<C-l>', '<C-v>', { noremap = true, silent = true })

-- Define a visual mode mapping for searching the highlighted text
vim.api.nvim_set_keymap('v', '<Leader>/', 'y/<C-R>"<CR>', { noremap = true, silent = true })


