return {
    "olimorris/codecompanion.nvim",
    dependencies = {
        "hrsh7th/nvim-cmp",
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "nvim-treesitter/nvim-treesitter",
        "nvim-telescope/telescope.nvim",
        "MeanderingProgrammer/render-markdown.nvim",
    },
    version = "*",
    event = "VeryLazy",
    config = function()
        -- https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua
        require("codecompanion").setup({
            display = {
                chat = {
                    window = {
                        width = 0.35,
                    }
                }
            },
            adapters = {
                acp = {
                    claude_code = function()
                        return require("codecompanion.adapters").extend("claude_code", {
                            env = {
                                ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_AUTH_TOKEN"),
                            },
                        })
                    end,
                },
            },
            strategies = {
                chat = {
                    adapter = "claude_code",
                },
                inline = {
                    adapter = "deepseek",
                },
                cmd = {
                    adapter = "deepseek",
                }
            }
        })
    end,
    opts = {},
    keys = {
        { "<leader>cc", "<cmd>CodeCompanionChat Toggle<cr>", desc = "codecompanion chat" },
        { "<leader>ca", "<cmd>CodeCompanionActions<cr>",     desc = "codecompanion action" },
    },
}
