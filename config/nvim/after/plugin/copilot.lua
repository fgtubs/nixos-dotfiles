-- Toggle GitHub Copilot on and off with a custom keybinding
vim.api.nvim_set_keymap('n', '<leader>co', ':Copilot enable<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>cf', ':Copilot disable<CR>', { noremap = true, silent = true })

-- Remap next and previous suggestion in insert mode
vim.api.nvim_set_keymap('i', '<C-j>', '<Plug>(copilot-next)', { noremap = false, silent = true })
vim.api.nvim_set_keymap('i', '<C-k>', '<Plug>(copilot-prev)', { noremap = false, silent = true })

