return {
    {
        "hrsh7th/nvim-cmp",
        event = { "InsertEnter", "CmdLineEnter" },
        dependencies = {
            { "onsails/lspkind-nvim" }, -- lspkind (VS pictograms)
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-cmdline" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "hrsh7th/cmp-nvim-lua" },
            -- { "hrsh7th/cmp-nvim-lsp-signature-help" },
            --{
            --    "hrsh7th/cmp-vsnip",
            --    dependencies = {
            --        { "hrsh7th/vim-vsnip" },
            --        { "hrsh7th/vim-vsnip-integ" },
            --        { "rafamadriz/friendly-snippets" },
            --    },
            --},
            {
                "saadparwaiz1/cmp_luasnip",
                dependencies = {
                    "L3MON4D3/LuaSnip",
                    version = "v2.*",
                    build = "make install_jsregexp",
                    dependencies = { -- Snippets
                        { "honza/vim-snippets" },
                        -- { "rafamadriz/friendly-snippets" },
                    },
                    config = function()
                        -- require("luasnip.loaders.from_vscode").lazy_load()
                        require("luasnip.loaders.from_snipmate").lazy_load()
                    end
                }
            }
        },
        config = function()
            require("config.nvimcmp")
        end,
    },
}
