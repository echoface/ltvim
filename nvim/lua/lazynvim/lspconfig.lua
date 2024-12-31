return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "hrsh7th/cmp-nvim-lsp" },
        { "nvimtools/none-ls.nvim" },
        { "ray-x/lsp_signature.nvim" },
        { "williamboman/mason.nvim",           version = "*" },
        { "jay-babu/mason-null-ls.nvim",       version = "*" },
        { "williamboman/mason-lspconfig.nvim", version = "*" },
        {
            "folke/lazydev.nvim",
            ft = "lua",
            opts = {
                library = {
                    { path = "luvit-meta/library", words = { "vim%.uv" } },
                },
            },
            dependencies = {
                { "Bilal2453/luvit-meta", lazy = true },
            },
        },
    },
    config = function()
        require("config.lsp")
    end
}
