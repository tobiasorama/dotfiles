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

vim.filetype.add({
  pattern = {
    ['.*idcl'] = 'idcl',
  },
})

local parser_config = require "nvim-treesitter.parsers".get_parser_configs()
parser_config.idcl = {
  install_info = {
    url = "~/repos/tree-sitter-idcl", -- Path to the tree-sitter-idcl repo
    files = {"src/parser.c"},
    -- optional entries:
    branch = "master", -- default branch in case of git repo if different from master
    generate_requires_npm = false, -- if stand-alone parser without npm dependencies
    requires_generate_from_grammar = false, -- if folder contains pre-generated src/parser.c
  },
}

