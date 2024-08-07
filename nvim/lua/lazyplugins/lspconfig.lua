return {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        { "folke/neodev.nvim" },        -- dev for neovim or config
        { "nvimtools/none-ls.nvim" },
        { "ray-x/lsp_signature.nvim" }, -- display func signatures
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },
    },
    config = function()
        require("config.lsp")
    end -- run lsp/init.lua
}
