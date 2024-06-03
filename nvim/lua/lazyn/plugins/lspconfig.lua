return {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    dependencies = {
        { "folke/neodev.nvim" },        -- dev for neovim or config
        { "nvimtools/none-ls.nvim" },
        { "ray-x/lsp_signature.nvim" }, -- display func signatures
        { "williamboman/mason.nvim" },
        { "williamboman/mason-lspconfig.nvim" },
        {
            "ray-x/navigator.lua",
            dependencies = {
                { "hrsh7th/nvim-cmp" },
                { "ray-x/guihua.lua", run = "cd lua/fzy && make" },
            },
            config = function()
                require("navigator").setup({
                    lsp_signature_help = true, -- enable ray-x/lsp_signature
                    lsp = { format_on_save = false }
                })
            end
        },
    },
    config = function()
        require("neodev").setup()
        require("lsp_signature").setup()

        require("mason").setup()
        local mason_lspconfig = require("mason-lspconfig")

        mason_lspconfig.setup()


        -- user defined lsp handlers
        require("lazyn.lsp.null-ls")

        local lspconfig = require("lspconfig")
        local lsphandler = require("lazyn.lsp.handlers")
        -- lspconfig setup (a automatic way powered by mason_lspconfig)
        -- more detail see `:h mason-lspconfig-automatic-server-setup`
        mason_lspconfig.setup_handlers {
            function(server_name) -- default handler (optional)
                local opts = {
                    on_attach = lsphandler.on_attach,
                    capabilities = lsphandler.capabilities,
                }

                local user_option_path = "user.lsp.settings." .. server_name
                local hit, lsp_extra = pcall(require, user_option_path)
                if hit and lsp_extra.setup_opts then
                    opts = vim.tbl_deep_extend("force", opts, lsp_extra.setup_opts)
                    vim.api.nvim_notify("use customized setup options for " .. server_name, 5, {})
                end

                lspconfig[server_name].setup(opts)
            end,
        }
    end
}
