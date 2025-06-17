return {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    version = "*",
    dependencies = {
        { "nvimtools/none-ls.nvim" },
        { "neovim/nvim-lspconfig",             version = "*" },
        { "ray-x/lsp_signature.nvim",          version = "*" },
        { "williamboman/mason.nvim",           version = "*" },
        { "jay-babu/mason-null-ls.nvim",       version = "*" },
        { "williamboman/mason-lspconfig.nvim", version = "*" },
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
