return {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    version = "*",
    dependencies = {
        { "nvimtools/none-ls.nvim" },
        { "neovim/nvim-lspconfig",             version = "*" },
        { "williamboman/mason.nvim",           version = "*" },
        { "williamboman/mason-lspconfig.nvim", version = "*" },
        {
            "jay-babu/mason-null-ls.nvim",
            version = "*",
            dependencies = {
                "williamboman/mason.nvim",
                "nvimtools/none-ls.nvim",
            },
            opts = {
                ensure_installed = {},
                automatic_installation = false,
            },
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
        require("config.lsp")
    end
}
