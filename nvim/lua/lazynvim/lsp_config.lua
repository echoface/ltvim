return {
    "williamboman/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    version = "v2.*",
    dependencies = {
        { "neovim/nvim-lspconfig",             version = "v2.*" },
        { "williamboman/mason.nvim",           version = "v2.*" },
    },
    config = function()
        require("config.setuplsp")
    end
}
