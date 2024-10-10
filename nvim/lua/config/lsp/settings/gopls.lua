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
local function run_specific_code_action(action_kind)
	local opts = {
		apply = true,
		context = {
			only = { action_kind }
		},
	}
	vim.lsp.buf.code_action(opts)
end

vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function()
		vim.lsp.buf.format({async = false})
	end,
})

M = {}
M.setup_opts = {
    settings = {
        gopls = {
            gofumpt = false,
            usePlaceholders = false,
            hoverKind = "NoDocumentation",
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
        },
    },
}

-- /*first arg client is ignored */
M.on_attach = function(client, bufnr)
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap

    vim.api.nvim_buf_create_user_command(bufnr, "GoImports", function()
        run_specific_code_action("source.organizeImports", nil)
    end, {})

    keymap(bufnr, "i", ",f", "<cmd>:GoFillStruct<cr>", opts)
    vim.api.nvim_buf_create_user_command(bufnr, "GoFillStruct", function()
        run_specific_code_action("refactor.rewrite", nil)
    end, {})

    vim.api.nvim_buf_create_user_command(bufnr, "GoExtractMethod", function()
        run_specific_code_action("refactor.extract", nil)
    end, {})

end

return M
