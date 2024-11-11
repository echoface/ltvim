return {
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdLineEnter" },
        dependencies = {
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-cmdline" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },
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
            { "https://code.byted.org/chenjiaqi.cposture/codeverse.vim.git" },
        },
        config = function()
            require("config.nvimcmp")
        end,
    },
}
