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
            ft = "lua", -- only load on lua files
            opts = {
                library = {
                    -- 需要包含的lua依赖库路径
                    -- "~/projects/my-awesome-lib",
                    { path = "luvit-meta/library", words = { "vim%.uv" } },
                },
                -- disable when a .luarc.json file is found
                enabled = function(root_dir)
                    return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
                end,
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
