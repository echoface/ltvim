return {
    { "f-person/auto-dark-mode.nvim", opts = {} },
    {
        "savq/melange-nvim",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("melange")
        end
    },
    {
        "loctvl842/monokai-pro.nvim",
        -- priority = 1000,
        config = function()
            require("monokai-pro").setup({
                day_night = {
                    enable = true,        -- turn off by default
                    day_filter = "light", -- classic | octagon | pro | machine | ristretto | spectrum
                    night_filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
                },
            })
        end
    },
    {
        'sainnhe/sonokai',
        -- priority = 1000,
        config = function()
            vim.g.sonokai_style = 'espresso'
            -- 'default', 'atlantis', 'andromeda',
            -- 'shusia', 'maia', 'espresso'
            vim.g.sonokai_enable_italic = true
            vim.g.sonokai_better_performance = 1
            -- vim.cmd.colorscheme('sonokai')
        end
    },
    {
        "morhetz/gruvbox",
        -- priority = 1000,
        config = function()
            vim.g.gruvbox_bold = 1
            vim.g.gruvbox_italic = 1
            -- vim.cmd.colorscheme("gruvbox")
        end,
    },
}

