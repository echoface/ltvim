-- It's important that you set up the plugins in the following order:
--
-- mason.nvim
-- mason-lspconfig.nvim
-- Setup servers via lspconfig
-- Pay extra attention to this if you lazy-load plugins, or somehow "chain" the loading of plugins via your plugin manager.

require("mason").setup()

local mason_lspconfig = require("mason-lspconfig")

mason_lspconfig.setup({
    ensure_installed = {}
})

-- lspconfig setup (a automatic way powered by mason_lspconfig)
-- more detail see `:h mason-lspconfig-automatic-server-setup`
local lspconfig = require("lspconfig")
local lsphandler = require("config.lsp.handlers")
mason_lspconfig.setup_handlers {
    function(server_name) -- default handler (optional)
        local opts = {
            on_attach = lsphandler.on_attach,
            capabilities = lsphandler.capabilities,
        }

        local user_option_path = "config.lsp.settings." .. server_name
        local hit, lsp_extra = pcall(require, user_option_path)
        if hit and lsp_extra.setup_opts then
            opts = vim.tbl_deep_extend("force", opts, lsp_extra.setup_opts)
        end

        lspconfig[server_name].setup(opts)
    end,
}

require("lazydev").setup() -- it's will register lazydev source automatically

require("config.lsp.null-ls")

require("lsp_signature").setup({
    hint_enable = false,    -- virtual hint
    floating_window = true, -- show hint in a floating window, false for virtual text only mode
    floating_window_above_cur_line = true,
})
