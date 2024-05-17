-- It's important that you set up the plugins in the following order:
--
-- mason.nvim
-- mason-lspconfig.nvim
-- Setup servers via lspconfig
-- Pay extra attention to this if you lazy-load plugins, or somehow "chain" the loading of plugins via your plugin manager.

require("user.lsp.null-ls")
require("lsp_signature").setup({
    timer_interval = 1000,
})
-- IMPORTANT: make sure to setup neodev BEFORE lspconfig
local neodev_ok, neodev = pcall(require, "neodev")
if neodev_ok then
    neodev.setup({})
end


local mason = require("mason")
local lspconfig = require("lspconfig")
local mason_lspconfig = require("mason-lspconfig")

mason.setup()
mason_lspconfig.setup({
    ensure_installed = { "lua_ls", "gopls", "vimls", "thriftls", "pyright", "jsonls", "clangd" },
})

-- user defined lsp handlers
local lsphandler = require("user.lsp.handlers")
lsphandler.setup()

-- lspconfig setup (a automatic way powered by mason_lspconfig)
-- more detail see `:h mason-lspconfig-automatic-server-setup`
mason_lspconfig.setup_handlers {
    function(server_name) -- default handler (optional)
        local opts = {
            on_attach = lsphandler.on_attach,
            capabilities = lsphandler.capabilities,
        }
        local server_custom_opts_define = "user.lsp.settings." .. server_name
        local has_custom_opts, server_custom_opts = pcall(require, server_custom_opts_define)
        if has_custom_opts then
            opts = vim.tbl_deep_extend("force", opts, server_custom_opts)
        end
        lspconfig[server_name].setup(opts)
    end,
}
