local M = {}

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then
    return
end

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)
M.capabilities.textDocument.completion.completionItem.snippetSupport = true

M.setup = function()
    local diagnostic_signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(diagnostic_signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
    end

    vim.diagnostic.config({
        virtual_text = false, -- disable virtual text
        update_in_insert = true, -- update diagnostic edit
        signs = { active = diagnostic_signs, }, -- show signs
        float = {
            focusable = true,
            style = "minimal",
            border = "rounded",
            source = "always",
        },
    })

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
    })
end

local function lsp_keymaps(bufnr)
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap
    keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    keymap(bufnr, "n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    keymap(bufnr, "n", "gs", "<cmd>lua vim.lsp.buf.document_symbol()<CR>", opts)
    -- diagnostic
    keymap(bufnr, "n", "ge", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
    -- lsp action instruction
    keymap(bufnr, "n", "rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    keymap(bufnr, "n", "ac", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    keymap(bufnr, "n", "fmt", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)

    vim.cmd("command! Rename lua vim.lsp.buf.rename()<cr>")
    vim.cmd('command! Format lua vim.lsp.buf.format({async = true})<cr>')
    vim.cmd('command! FixIt  lua vim.lsp.buf.code_action()<cr>')
    vim.cmd('command! SignsHelp lua vim.lsp.buf.signature_help()<cr>')
    vim.cmd('command! SymbolList lua vim.lsp.buf.document_symbol()<cr>')
    vim.cmd('command! Diagnostics lua vim.diagnostic.open_float()<cr>')
    vim.cmd('command! PrevDiagnostics lua vim.diagnostic.goto_prev({buffer=0})<cr>')
    vim.cmd('command! NextDiagnostics lua vim.diagnostic.goto_next({buffer=0})<cr>')

    vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]
end

M.on_attach = function(client, bufnr)
    if client.name == "tsserver" then
        client.server_capabilities.document_formatting = false
    end

    lsp_keymaps(bufnr)

    local status_ok, illuminate = pcall(require, "illuminate")
    if status_ok then
        illuminate.on_attach(client)
    end
end

return M
