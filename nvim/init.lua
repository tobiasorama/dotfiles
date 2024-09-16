require("config.lazy")

-- Basic settings
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.autoindent = true

vim.wo.number = true
vim.wo.relativenumber = true


-- Plugin settings

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>sf', builtin.find_files, {})
vim.keymap.set('n', '<leader>sg', builtin.live_grep, {})
vim.keymap.set('n', '<leader><leader>', builtin.buffers, {})

require("gitsigns").setup {
   signs = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signs_staged = {
      add          = { text = '┃' },
      change       = { text = '┃' },
      delete       = { text = '_' },
      topdelete    = { text = '‾' },
      changedelete = { text = '~' },
      untracked    = { text = '┆' },
    },
    signs_staged_enable = true,
    signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
    numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
      follow_files = true
    },
    auto_attach = true,
    attach_to_untracked = false,
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
      virt_text_priority = 100,
      use_focus = true,
    },
    current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000, -- Disable if file is longer than this (in lines)
    preview_config = {
      -- Options passed to nvim_open_win
      border = 'single',
      style = 'minimal',
      relative = 'cursor',
      row = 0,
      col = 1
    },
}

vim.cmd[[
    set termguicolors
    colorscheme pink-moon
    set background=dark
]]

-- Fix signcolumn
vim.api.nvim_set_hl(0, "SignColumn", {ctermbg=NONE})
vim.api.nvim_set_hl(0, "GitSignsAdd", {ctermfg=121, ctermbg=NONE})
vim.api.nvim_set_hl(0, "GitSignsChange", {ctermfg=12, ctermbg=NONE})
vim.api.nvim_set_hl(0, "GitSignsDelete", {ctermfg=1, ctermbg=NONE})
vim.api.nvim_set_hl(0, "GitSignsChangedelete", {ctermfg=1, ctermbg=NONE})
vim.api.nvim_set_hl(0, "GitSignsTopdelete", {ctermfg=1, ctermbg=NONE})
vim.api.nvim_set_hl(0, "GitSignsUntracked", {ctermfg=cleared, ctermbg=NONE})
