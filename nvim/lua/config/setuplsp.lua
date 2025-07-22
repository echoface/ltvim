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

vim.cmd("command! Rename lua vim.lsp.buf.rename()<cr>")
-- vim.cmd('command! Format lua vim.lsp.buf.format({async = true})<cr>')
vim.api.nvim_create_user_command('LspFormat', function()
    local bufnr = vim.api.nvim_get_current_buf()
    formatutil.format_with_priority(bufnr, true, 3000, "null-ls")
end, {})
vim.cmd('command! LspSignsHelp lua vim.lsp.buf.signature_help()<cr>')
vim.cmd('command! LspDocSymbols lua vim.lsp.buf.document_symbol()<cr>')
vim.cmd('command! LspOutGoingCalls lua vim.lsp.buf.outgoing_calls()<cr>')
vim.cmd('command! LspInComingCalls lua vim.lsp.buf.incoming_calls()<cr>')

local shared_on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap
    keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    keymap(bufnr, "n", "gs", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
    keymap(bufnr, "n", "sh", "<cmd>lua vim.lsp.buf.signature_help({async = true})<cr>", opts)
    -- lsp action instruction
    keymap(bufnr, "n", "F", "<cmd>LspCodeAction <cr>", opts)
    keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)

    vim.notify("lsp [" .. client.name .. "] on_attach", vim.log.levels.INFO)

    local status_ok, illuminate = pcall(require, "illuminate")
    if status_ok then
        illuminate.on_attach(client)
    end
end

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

        shared_on_attach(client, args.buf)
    end,
})
