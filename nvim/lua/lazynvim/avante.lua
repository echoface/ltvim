return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    opts = {
        -- debug = false,
        provider = "claude-code",
        instructions_file = "AGENTS.md",
        auto_suggestions_provider = "deepseek", -- Since auto-suggestions are a high-frequency operation and therefore expensive, it is recommended to specify an inexpensive provider or even a free provider: copilot
        providers = {
            deepseek = {
                __inherited_from = "openai",
                model = "deepseek-chat",
                api_key_name = "DEEPSEEK_API_KEY",
                endpoint = "https://api.deepseek.com",
            },
        },
        acp_providers = {
            ["claude-code"] = {
                command = "npx",
                args = { "@zed-industries/claude-code-acp" },
                env = {
                    NODE_NO_WARNINGS = "1",
                    ANTHROPIC_BASE_URL = os.getenv("ANTHROPIC_BASE_URL"),
                    ANTHROPIC_API_KEY = os.getenv("ANTHROPIC_AUTH_TOKEN"),
                    ACP_PATH_TO_CLAUDE_CODE_EXECUTABLE = vim.fn.exepath("claude"),
                    ACP_PERMISSION_MODE = "bypassPermissions",
                },
            },
        },
        selector = {
            provider = "telescope", -- native|mini_pick|telescope
        },
        windows = {
            input = {
                prefix = "> ",
                height = 8, -- Height of the input window in vertical layout
            },
        },
    },
    build = "make", -- if you want to build from source then do `make BUILD_FROM_SOURCE=true"
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        --- The below dependencies are optional,
        "hrsh7th/nvim-cmp",            -- autocompletion for avante commands and mentions
        "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
        {
            'echasnovski/mini.pick',
            version = false,
            config = function()
                -- Centered on screen
                local win_config = function()
                    local height = math.floor(0.618 * vim.o.lines)
                    local width = math.floor(0.618 * vim.o.columns)
                    return {
                        anchor = 'NW',
                        height = height,
                        width = width,
                        row = math.floor(0.5 * (vim.o.lines - height)),
                        col = math.floor(0.5 * (vim.o.columns - width)),
                    }
                end
                require("mini.pick").setup({ window = { config = win_config } })
            end
        },
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
            ft = { "markdown", "Avante" },
            opts = {
                file_types = { "markdown", "Avante" },
            },
        },
    },
}
