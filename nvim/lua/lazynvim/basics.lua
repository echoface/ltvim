return {
    -- other simple enough plugin
    { "moll/vim-bbye",                event = "VeryLazy" },
    { "APZelos/blamer.nvim",          event = "VeryLazy" },
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
        priority = 1000,
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
            -- 'default', 'atlantis', 'andromeda', 'shusia', 'maia', 'espresso'
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
            vim.g.gruvbox_contrast_light = "soft"
            -- vim.cmd.colorscheme("gruvbox")
        end,
    },
    {
        'rcarriga/nvim-notify',
        config = function()
            vim.notify = require("notify")
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        config = function()
            require("config.gitsigns")
        end
    },
    {
        "easymotion/vim-easymotion",
        event = "VeryLazy",
        config = function() require("config.easymotion") end
    },
    {
        "terrortylor/nvim-comment",
        event = "VeryLazy",
        name = "nvim_comment",
        opts = { comment_empty = false },
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = true,
    },
    {
        "ntpeters/vim-better-whitespace",
        event = "VeryLazy",
        init = function()
            vim.g.better_whitespace_filetypes_blacklist = {
                'diff', 'git', 'gitcommit', 'unite', 'qf',
                'help', 'markdown', 'fugitive', 'alpha',
                'NeogitStatus', 'Avante', 'AvanteInput', "AvanteTodos"
            }
            vim.g.better_whitespace_enabled = true
            vim.g.better_whitespace_shows_end_of_line = true
        end
    },
}
