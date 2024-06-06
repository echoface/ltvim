-- global lsp init

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded",
})
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        -- disable diagnostics insert mode; delay update diagnostics
        update_in_insert = false,
    }
)

vim.cmd("command! Rename lua vim.lsp.buf.rename()<cr>")
vim.cmd('command! Format lua vim.lsp.buf.format({async = true})<cr>')
vim.cmd('command! CodeAction lua vim.lsp.buf.code_action()<cr>')
vim.cmd('command! SignsHelp lua vim.lsp.buf.signature_help()<cr>')
vim.cmd('command! ListSymbols lua vim.lsp.buf.document_symbol()<cr>')


local M = {}

local nvim_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
M.capabilities = vim.lsp.protocol.make_client_capabilities()
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
    keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    keymap(bufnr, "n", "gs", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
    keymap(bufnr, "n", "sh", "<cmd>lua vim.lsp.buf.signature_help({async = true})<cr>", opts)
    -- lsp action instruction
    keymap(bufnr, "n", "rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    keymap(bufnr, "n", "ca", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    keymap(bufnr, "n", "fmt", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)

    local user_option_path = "config.lsp.settings." .. client.name
    local hit, user_option = pcall(require, user_option_path)
    if hit and user_option.customized_keymapping then
        user_option.customized_keymapping(client, bufnr)
    end

    local status_ok, illuminate = pcall(require, "illuminate")
    if status_ok then
        illuminate.on_attach(client)
    end
end

return M
