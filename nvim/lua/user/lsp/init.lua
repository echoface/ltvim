local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
  return
end

require("user.lsp.null-ls")
require("lsp_signature").setup({-- can also configure a border style, see readme for more detail
  timer_interval = 1000,
})

local lsp_servers = {
    "gopls",
    "clangd",
    "lua_ls",
    "vimls",
    "jsonls",
    "bashls",
    "yamlls",
    "pyright"
}

------ lsp installer ------
local mason_ok, mason = pcall(require, "mason")
if not mason_ok then
	return
end
local mason_config_ok, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_config_ok then
	return
end
mason.setup()
mason_lspconfig.setup()
mason_lspconfig.setup_handlers {
    -- The first entry (without a key) will be the default handler
    -- and will be called for each installed server that doesn't have
    -- a dedicated handler.
    function (server_name) -- default handler (optional)
        require("lspconfig")[server_name].setup {}
    end,
    -- Next, you can provide a dedicated handler for specific servers.
    -- For example, a handler override for the `rust_analyzer`:
    ["rust_analyzer"] = function ()
        require("rust-tools").setup {}
    end
}

------  setup lsp for lspconfig ------
local lsphandler = require("user.lsp.handlers")
for _, server in pairs(lsp_servers) do
	local opts = {
		on_attach = lsphandler.on_attach,
		capabilities = lsphandler.capabilities,
	}
	local has_custom_opts, server_custom_opts = pcall(require, "user.lsp.settings." .. server)
	if has_custom_opts then
		opts = vim.tbl_deep_extend("force", opts, server_custom_opts)
	end
	lspconfig[server].setup(opts)
end

lsphandler.setup()
