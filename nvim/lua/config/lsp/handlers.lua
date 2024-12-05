-- global lsp init

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
    vim.lsp.handlers.hover, {
        border = "rounded",
    })
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, {
        border = "rounded",
    })
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        -- disable diagnostics insert mode; delay update diagnostics
        update_in_insert = false,
    }
)

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
vim.cmd("command! Rename lua vim.lsp.buf.rename()<cr>")
vim.cmd('command! Format lua vim.lsp.buf.format({async = true})<cr>')
vim.cmd('command! LspSignsHelp lua vim.lsp.buf.signature_help()<cr>')
vim.cmd('command! LspDocSymbols lua vim.lsp.buf.document_symbol()<cr>')
vim.cmd('command! LspOutGoingCalls lua vim.lsp.buf.outgoing_calls()<cr>')
vim.cmd('command! LspInComingCalls lua vim.lsp.buf.incoming_calls()<cr>')


local M = {}
M.capabilities = vim.lsp.protocol.make_client_capabilities()

local nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if nvim_lsp_ok then
    M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)
end
-- M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities.textDocument.completion.completionItem.resolveSupport = {
    properties = { "documentation", "detail", "additionalTextEdits" },
}

M.on_attach = function(client, bufnr)
    -- setup keymapping
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

    -- lsp nvimcmplsp
    local user_option_path = "config.lsp.settings." .. client.name
    local ok, user_option = pcall(require, user_option_path)
    if ok and user_option.on_attach then
        user_option.on_attach(client, bufnr)
    end

    local status_ok, illuminate = pcall(require, "illuminate")
    if status_ok then
        illuminate.on_attach(client)
    end
end

return M
