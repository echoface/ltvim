return {
    -- other simple enough plugin
    { "moll/vim-bbye",       event = "VeryLazy" },
    { "APZelos/blamer.nvim", event = "VeryLazy" },
    {
        "rcarriga/nvim-notify",
        event = "VimEnter",
        config = function()
            vim.notify = require("notify")
        end
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
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function() require("Comment").setup() end
    },
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function()
            require("config.autopairs")
        end
    },
    {
        "ntpeters/vim-better-whitespace",
        event = "VeryLazy",
        config = function()
            vim.g.better_whitespace_filetypes_blacklist = {
                'diff', 'git', 'gitcommit', 'unite', 'qf',
                'help', 'markdown', 'fugitive', 'alpha'
            }
        end
    },
}
