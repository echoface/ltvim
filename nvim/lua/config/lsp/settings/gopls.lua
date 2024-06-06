M = {}
M.setup_opts = {
    settings = {
        gopls = {
            gofumpt = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
        },
    },
}

local function organize_imports()
    -- vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 1000)
    for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, "UTF-8")
            else
                vim.lsp.buf.execute_command(r.command)
            end
        end
    end
end

M.customized_keymapping = function(client, bufnr)
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap

    -- golang
    keymap(bufnr, "i", ",f", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)

    vim.api.nvim_buf_create_user_command(bufnr, "GoImports", organize_imports, {})
    vim.api.nvim_buf_create_user_command(bufnr, "GoFillStruct", function()
        vim.lsp.buf.code_action({ apply = true, context = { only = { "refactor.rewrite" } }, })
    end, {})
end

return M
