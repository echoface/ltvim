-- vim.lsp.set_log_level("debug")

-- 全局设置
vim.lsp.config("*", {
    flags = {
        debounce_text_changes = 300, -- Debounce settings can improve performance
    },
})
vim.lsp.config("gopls", {
    cmd = { "gopls", "-rpc.trace", "-logfile", "/tmp/gopls.log" },
    root_markers = { 'go.mod', 'go.work', '.git' },
})

-- global lsp init
local filter_kinds = {
    "source.doc",
    "source.assembly",
    -- 可以在这里继续添加更多要过滤的kind值，比如 "source.other_type" 等
}
vim.api.nvim_create_user_command('LspCodeAction', function()
    vim.lsp.buf.code_action({
        filter = function(action)
            -- vim.notify(vim.inspect(action))
            for _, kind_to_filter in ipairs(filter_kinds) do
                if action.kind == kind_to_filter then
                    return false
                end
            end
            return true
        end
    })
end, {})

local formatutil = require("config.util.formating")
formatutil.setup({
    idlfmt_ftypes = {},
})

vim.api.nvim_create_user_command('Format', function()
    local bufnr = vim.api.nvim_get_current_buf()
    formatutil.format_with_priority(bufnr, true, 3000, "null-ls")
end, {})
vim.api.nvim_create_user_command("Hover", function ()
    vim.lsp.buf.hover()
end, {})
vim.api.nvim_create_user_command('Hover', function()
    vim.lsp.buf.hover()
end, {})
vim.api.nvim_create_user_command('Rename', function()
    vim.lsp.buf.rename()
end, {})
vim.api.nvim_create_user_command('LspDocSymbols', function()
    vim.lsp.buf.document_symbol()
end, {})
vim.api.nvim_create_user_command('LspOutGoingCalls', function()
    vim.lsp.buf.outgoing_calls()
end, {})
vim.api.nvim_create_user_command('LspInComingCalls', function()
    vim.lsp.buf.incoming_calls()
end, {})

require("lspconfig")
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {},
    automatic_enable = {
        exclude = {
            "ts_ls"
        }
    },
})

-- local lsp_signature = require("lsp_signature")

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('ltvim.lsp', {}),
    callback = function(args)
        local bufnr = args.buf
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

        -- version = "*", 0.11 兼容问题, https://github.com/ray-x/lsp_signature.nvim/pull/355
        -- lsp_signature.on_attach({
        --     bind = true,
        --     debug = false,
        --     hint_enable = false, -- virtual hint
        --     handler_opts = {
        --         border = "rounded"
        --     }
        -- }, 0)

        local keymap = vim.keymap.set
        local opts = { noremap = true, silent = true, buffer = bufnr }
        local ok, tb = pcall(require, "telescope.builtin")
        if ok then
            keymap('n', 'gr', tb.lsp_references, opts)
            keymap('n', 'gd', tb.lsp_definitions, opts)
            keymap('n', 'gi', tb.lsp_implementations, opts)
            keymap('n', 'gs', tb.lsp_document_symbols, opts)
        else
            keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
            keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
            keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
            keymap("n", "gs", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
        end
        keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        -- lsp action instruction
        keymap("n", "F", "<cmd>LspCodeAction <cr>", opts)
        keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)

        local status_ok, illuminate = pcall(require, "illuminate")
        if status_ok then
            illuminate.on_attach(client)
        end
    end,
})
