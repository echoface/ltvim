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
    {
        "https://code.byted.org/chenjiaqi.cposture/codeverse.vim.git",
        event = { "InsertEnter" },
        dependencies = {
            "hrsh7th/nvim-cmp",
        },
        init = function()
            -- 关闭 codeverse 内置 tab 映射
            vim.g.codeverse_no_map_tab = true
            -- 关闭 codeverse 内置补全映射
            vim.g.codeverse_disable_bindings = true
            -- 关闭 codeverse 内置自动补全
            vim.g.codeverse_disable_autocompletion = true
        end,
        config = function()
            require("codeverse").setup({})
        end
    },
}
