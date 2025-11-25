return {
    -- other simple enough plugin
    { "moll/vim-bbye",       event = "VeryLazy" },
    { "APZelos/blamer.nvim", event = "VeryLazy" },
    {
        "morhetz/gruvbox",
        priority = 1000,
        config = function()
            vim.g.gruvbox_bold = 1
            vim.g.gruvbox_italic = 1
            vim.g.gruvbox_transparent_bg = 1
            vim.o.background = "light" -- or "light" for light mode
            vim.cmd.colorscheme("gruvbox")
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
