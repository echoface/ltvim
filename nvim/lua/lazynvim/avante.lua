return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    lazy = false,
    version = "*", -- set this if you want to always pull the latest change
    opts = {
        -- debug = false,
        provider = "deepseek",                  -- Recommend using Claude
        auto_suggestions_provider = "deepseek", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
        openai = {
            endpoint = "https://api.deepseek.com/v1",
            model = "deepseek-chat",
            temperature = 0.0,
            max_tokens = 4096,
        },
        vendors = {
            deepseek = {
                __inherited_from = "openai",
                api_key_name = "DEEPSEEK_API_KEY",
                endpoint = "https://api.deepseek.com",
                model = "deepseek-coder",
                disable_tools = true,
            },
            deepseekr1 = {
                __inherited_from = "openai",
                api_key_name = "DEEPSEEK_API_KEY",
                endpoint = "https://api.deepseek.com",
                model = "deepseek-reasoner",
                disable_tools = true,
            },
        },
        file_selector = {
            provider = "telescope",
        },
    },
    build = "make", -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "stevearc/dressing.nvim",
        "nvim-treesitter/nvim-treesitter",
        --- The below dependencies are optional,
        "hrsh7th/nvim-cmp",              -- autocompletion for avante commands and mentions
        "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
        "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
        {
            -- support for image pasting
            "HakonHarnes/img-clip.nvim",
            event = "VeryLazy",
            opts = {
                -- recommended settings
                default = {
                    embed_image_as_base64 = false,
                    prompt_for_file_name = false,
                    drag_and_drop = {
                        insert_mode = true,
                    },
                    -- required for Windows users
                    use_absolute_path = true,
                },
            },
        },
        {
            -- Make sure to set this up properly if you have lazy=true
            'MeanderingProgrammer/render-markdown.nvim',
            version = "*",
            ft = { "markdown", "Avante" },
            opts = {
                file_types = { "markdown", "Avante" },
            },
        },
    },
}
