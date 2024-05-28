
-- diagnostics basic(none lsp related) config
local diagnostic_signs = {
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignError", text = "" },
}

for _, sign in ipairs(diagnostic_signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

vim.diagnostic.config({
    virtual_text = false,                   -- disable virtual text
    update_in_insert = false,               -- update diagnostic edit
    signs = { active = diagnostic_signs, }, -- show signs
    float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = true, -- 'if_many'
    },
})
vim.cmd('command! Diagnostics lua vim.diagnostic.open_float()<cr>')
vim.cmd('command! DiagnosticsPre lua vim.diagnostic.goto_prev({buffer=0})<cr>')
vim.cmd('command! DiagnosticsNext lua vim.diagnostic.goto_next({buffer=0})<cr>')
-- display diagnostics when cursor hold only in normal mode
vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})]]
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]


-- keymapping
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "ge", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
