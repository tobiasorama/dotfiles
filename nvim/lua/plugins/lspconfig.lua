return { "neovim/nvim-lspconfig",
    init = function()
        vim.api.nvim_create_autocmd('LspAttach', {
          desc = 'LSP actions',
          callback = function(event)
            local opts = {buffer = event.buf}

            vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
            vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
            vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
            vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
            vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
            vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', opts)
            vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
            vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
            vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
            vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
            vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
          end,
        })
    end,
    config = function()
        -- Lsp settings
        local lspconfig = require('lspconfig')
        lspconfig.rust_analyzer.setup {
            settings = {
                ['rust-analyzer'] = {},
            },
        }
        lspconfig.hls.setup {
            settings = {
                ['hls'] = {},
            },
        }
        lspconfig.clangd.setup {
            settings = {
                ['clangd'] = {},
            },
        }
        lspconfig.pyright.setup {
            settings = {
                ['pyright'] = {},
            },
        }
        lspconfig.lua_ls.setup {
            settings = {
                ['lua-language-server'] = {},
            },
        }
    end,
    enabled = true,
}
