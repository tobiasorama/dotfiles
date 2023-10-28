vim.cmd[[ let g:airline#extensions#tabline#enabled = 1 ]]
-- git clone git@github.com:powerline/fonts.git
-- cd fontd
-- ./install.sh
-- cd .. && rm -rf fontd
vim.cmd[[ let g:airline_powerline_fonts = 1 ]]
vim.cmd[[let g:airline#extensions#tabline#buffer_idx_mode = 1]]
vim.keymap.set('n', "<leader>1", "<Plug>AirlineSelectTab1")
vim.keymap.set('n', "<leader>2", "<Plug>AirlineSelectTab2")
vim.keymap.set('n', "<leader>3", "<Plug>AirlineSelectTab3")
vim.keymap.set('n', "<leader>4", "<Plug>AirlineSelectTab4")
vim.keymap.set('n', "<leader>5", "<Plug>AirlineSelectTab5")
vim.keymap.set('n', "<leader>6", "<Plug>AirlineSelectTab6")
vim.keymap.set('n', "<leader>7", "<Plug>AirlineSelectTab7")
vim.keymap.set('n', "<leader>8", "<Plug>AirlineSelectTab8")
vim.keymap.set('n', "<leader>9", "<Plug>AirlineSelectTab9")
vim.keymap.set('n', "<leader>0", "<Plug>AirlineSelectTab0")
vim.keymap.set('n', "<leader>-", "<Plug>AirlineSelectPrevTab")
vim.keymap.set('n', "<leader>+", "<Plug>AirlineSelectNextTab")
