-- It's important that you set up the plugins in the following order:
--
-- mason.nvim
-- mason-lspconfig.nvim
-- Setup servers via lspconfig
-- Pay extra attention to this if you lazy-load plugins, or somehow "chain" the loading of plugins via your plugin manager.

require("config.lsp.null-ls")
require("neodev").setup()
require("lsp_signature").setup({
    close_timeout = 1000,  -- close floating window after ms when laster parameter is entered
    floating_window = true, -- show hint in a floating window, false for virtual text only mode
    hint_enable = false, -- virtual hint
})
--vim.api.nvim_create_autocmd("LspAttach", {
--    callback = function(args)
--        local bufnr = args.buf
--        local client = vim.lsp.get_client_by_id(args.data.client_id)
--        if vim.tbl_contains({ 'null-ls' }, client.name) then -- blacklist lsp
--            return
--        end
--        require("lsp_signature").on_attach({
--            close_timeout = 1000,    -- close floating window after ms when laster parameter is entered
--            floating_window = true, -- show hint in a floating window, false for virtual text only mode
--            hint_enable = false, -- virtual hint
--        }, bufnr)
--    end,
--})

local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

mason.setup()
mason_lspconfig.setup()

local lspconfig = require("lspconfig")
-- user defined lsp handlers
local lsphandler = require("config.lsp.handlers")
-- lspconfig setup (a automatic way powered by mason_lspconfig)
-- more detail see `:h mason-lspconfig-automatic-server-setup`
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
