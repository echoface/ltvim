return {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    version = "v2.*",
    dependencies = {
        { "neovim/nvim-lspconfig",             version = "v2.*" },
        { "williamboman/mason.nvim",           version = "v2.*" },
        {
            "jay-babu/mason-null-ls.nvim",
            version = "*",
            opts = {
                ensure_installed = {},
                automatic_installation = false,
            },
        },
        {
            "nvimtools/none-ls.nvim",
            config = function()
                require("config.nonels")
            end,
        },
        {
            "ray-x/lsp_signature.nvim",
            -- version = "*", 0.11 兼容问题
            -- https://github.com/ray-x/lsp_signature.nvim/pull/355
            event = "InsertEnter",
            opts = {
                bind = true,
                debug = false,
                hint_enable = false, -- virtual hint
                handler_opts = {
                    border = "rounded"
                }
            }
        },
        {
            "folke/lazydev.nvim",
            ft = "lua",
            version = "*",
            opts = {
                library = {
                    { path = "luvit-meta/library", words = { "vim%.uv" } },
                },
            },
            dependencies = {
                { "Bilal2453/luvit-meta", lazy = true },
            },
            config = true,
        },
    },
    config = function()
        require("config.setuplsp")
    end
}
