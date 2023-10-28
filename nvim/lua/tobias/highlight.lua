-- highlight search term on/off
vim.cmd.set("hlsearch")
vim.keymap.set('n', "<Cr>", ":set hlsearch! hlsearch?<Cr>")

-- fix highlight
vim.cmd.colorscheme("default")
vim.api.nvim_set_hl(0, "SignColumn", {link = "NonText"})
