return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "hrsh7th/cmp-nvim-lsp" }, -- we use cmp-nvm-lsp, so ref to it's capabilities
        { "nvimtools/none-ls.nvim" },
        { "jay-babu/mason-null-ls.nvim" },
        { "ray-x/lsp_signature.nvim" }, -- display func signatures
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },
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
