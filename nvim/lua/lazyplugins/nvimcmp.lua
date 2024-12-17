return {
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdLineEnter" },
        dependencies = {
            { "hrsh7th/cmp-path",     version = "*" },
            { "hrsh7th/cmp-buffer",   version = "*" },
            { "hrsh7th/cmp-cmdline",  version = "*" },
            { "hrsh7th/cmp-nvim-lsp", version = "*" },
            { "hrsh7th/cmp-nvim-lua", version = "*" },
            {
                "saadparwaiz1/cmp_luasnip",
                dependencies = {
                    "L3MON4D3/LuaSnip",
                    version = "v2.*",
                    build = "make install_jsregexp",
                    dependencies = { -- Snippets
                        { "honza/vim-snippets" },
                    },
                    config = function()
                        -- require("luasnip.loaders.from_vscode").lazy_load()
                        require("luasnip.loaders.from_snipmate").lazy_load()
                    end
                }
            },
            {
                "zbirenbaum/copilot-cmp",
                enabled = false,
                config = function()
                    require("copilot_cmp").setup()
                end,
                dependencies = {
                    'zbirenbaum/copilot.lua',
                    cmd = 'Copilot',
                    event = 'InsertEnter',
                    config = function()
                        require("copilot").setup {
                            panel = { enabled = false },
                            suggestion = { enabled = false },
                            server_opts_overrides = {
                                -- trace = "verbose",
                                settings = {
                                    advanced = {
                                        listCount = 5,          -- #completions for panel
                                        inlineSuggestCount = 3, -- #completions for getCompletions
                                    }
                                },
                            }
                        }
                    end,
                },
            },
        },
        config = function()
            require("config.nvimcmp")
        end,
    },
    {
        "https://code.byted.org/chenjiaqi.cposture/codeverse.vim.git",
        init = function()
            vim.g.codeverse_no_map_tab = true
            vim.g.codeverse_disable_bindings = true
            vim.g.codeverse_disable_autocompletion = true
        end,
        config = function()
            require("codeverse").setup() -- it will register cmp source
        end,
    },
}
