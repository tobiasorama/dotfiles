-- force yourself to not use the arrow keys
vim.keymap.set('n', "<Up>",    "<nop>")
vim.keymap.set('n', "<Down>",  "<nop>")
vim.keymap.set('n', "<Left>",  "<nop>")
vim.keymap.set('n', "<Right>", "<nop>")
vim.keymap.set('i', "<Up>",    "<nop>")
vim.keymap.set('i', "<Down>",  "<nop>")
vim.keymap.set('i', "<Left>",  "<nop>")
vim.keymap.set('i', "<Right>", "<nop>")

vim.g.mapleader = " "
vim.keymap.set('n', "<leader>s", ":so ~/.config/nvim/init.vim<Cr>")
vim.keymap.set('n', "<C-d>", "<C-d>zz")
vim.keymap.set('n', "N", "Nzz")
