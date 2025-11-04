return {
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdLineEnter" },
        version = "*",
        dependencies = {
            { "hrsh7th/cmp-path",         version = "*" },
            { "hrsh7th/cmp-buffer",       version = "*" },
            { "hrsh7th/cmp-cmdline",      version = "*" },
            { "hrsh7th/cmp-nvim-lsp",     version = "*" },
            { "hrsh7th/cmp-nvim-lua",     version = "*" },
            { "saadparwaiz1/cmp_luasnip", },
            { "L3MON4D3/LuaSnip" },
        },
        config = function()
            require("config.nvimcmp").config()
        end,
    },
}
