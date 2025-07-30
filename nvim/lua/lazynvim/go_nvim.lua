return {
    'ray-x/go.nvim',
    dependencies = {
        'ray-x/guihua.lua', -- optional
        'neovim/nvim-lspconfig',
        'nvim-treesitter/nvim-treesitter',
    },
    opts = {}, -- by default lsp_cfg = false
    -- opts = { lsp_cfg = true } -- use go.nvim will setup gopls
    config = function(_, opts)
        opts.lsp_cfg = false
        opts.run_in_floaterm = true
        opts.floaterm = {                 -- position
            posititon = 'auto',           -- one of {`top`, `bottom`, `left`, `right`, `center`, `auto`}
            width = 1.0,                  -- width of float window if not auto
            height = 1.0,                -- height of float window if not auto
            title_colors = 'monokai',     -- default to nord, one of {'nord', 'tokyo', 'dracula', 'rainbow', 'solarized ', 'monokai'}
        }
        require("go").setup(opts)
    end
}
