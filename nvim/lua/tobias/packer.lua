-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use('nvim-treesitter/nvim-treesitter', {run =  ':TSUpdate'})
    use('tpope/vim-fugitive')
    use('preservim/nerdtree')
    use('airblade/vim-gitgutter')
    use('christoomey/vim-tmux-navigator')
    use('vim-airline/vim-airline')
    use('vim-airline/vim-airline-themes')
    use {
	    'neoclide/coc.nvim', branch = 'release'
    }

end)
