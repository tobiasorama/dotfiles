require("config.lazy")

-- Basic settings
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.autoindent = true
vim.o.ignorecase = true

vim.wo.number = true
vim.wo.relativenumber = true

vim.cmd[[
    set noincsearch
    set termguicolors
    colorscheme catppuccin
]]
