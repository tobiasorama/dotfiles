return { 'nvim-treesitter/nvim-treesitter',
         opts = function()
             require('nvim-treesitter.configs').setup {
                ensure_installed = {"c", "cpp", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline", "rust" },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                }
             }
         end,
}
