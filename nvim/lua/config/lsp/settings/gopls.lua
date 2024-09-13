-- CodeActionKind
--- ""                          # Empty
--- "quickfix"                  # QuickFix
--- "refactor"                  # Refactor
--- "refactor.extract"          # RefactorExtract
--- "refactor.inline"           # RefactorInline
--- "refactor.rewrite"          # RefactorRewrite
--- "source"                    # Source
--- "source.fixAll"             # SourceFixAll
--- "source.organizeImports"    # SourceOrganizeImports
local function run_specific_code_action(action_kind, filter_func)
    local opts = {
        apply = true,
        context = {
            only = { action_kind }
        },
    }
    if filter_func then
        opts.filter = filter_func
    end
    vim.lsp.buf.code_action(opts)
end

local organize_imports_sync = function(bufnr, isPreflight)
    local encoding = vim.lsp.util._get_offset_encoding()
    local params = vim.lsp.util.make_range_params(nil, encoding)
    params.context = { only = { "source.organizeImports" } }

    if isPreflight then
        vim.lsp.buf_request(bufnr, "textDocument/codeAction", params, function() end)
        return
    end

    local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params, 3000)
    for _, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                vim.lsp.util.apply_workspace_edit(r.edit, encoding)
            else
                vim.lsp.buf.execute_command(r.command)
            end
        end
    end
end


M = {}
M.setup_opts = {
    settings = {
        gopls = {
            gofumpt = true,
            usePlaceholders = true,
            hoverKind = "NoDocumentation",
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
        },
    },
}

-- /*first arg client is ignored */
M.on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap

    vim.api.nvim_create_autocmd("BufWritePre", {
      callback = function()
         vim.lsp.buf.format({async = false})
      end,
    })
    vim.api.nvim_buf_create_user_command(bufnr, "GoImports", function()
        run_specific_code_action("source.organizeImports", nil)
    end, {})

    vim.api.nvim_buf_create_user_command(bufnr, "GoFillStruct", function()
        run_specific_code_action("refactor.rewrite", nil)
    end, {})
    keymap(bufnr, "i", ",f", "<cmd>:GoFillStruct<cr>", opts)

    vim.api.nvim_buf_create_user_command(bufnr, "GoExtractMethod", function()
        run_specific_code_action("refactor.extract", nil)
    end, {})

end

return M
