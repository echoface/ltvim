return {
    "yetone/avante.nvim",
    event = "VeryLazy",
    version = false,
    ---@module 'avante'
    ---@type avante.Config
    opts = {
        provider = "claude-code",
        instructions_file = "AGENTS.md",
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
                command = "claude-code-acp", -- npx
                args = {},                   -- { "@zed-industries/claude-code-acp" },
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
            provider = "native", -- native|mini_pick|telescope
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
    },
}
