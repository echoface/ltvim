local function apply_action(client, bufnr, action)
    -- vim.notify('gopls apply_action ' .. vim.inspect(action), vim.log.levels.INFO)
    if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
    end

    if not action.command then
        vim.notify('action without command, nothing can do', vim.log.levels.INFO)
        return
    end

    local command = type(action.command) == 'table' and action.command or action
    local fn = client.commands[command.command] or vim.lsp.commands[command.command]
    if fn then
        return fn(command, vim.deepcopy({ bufnr = bufnr, client_id = client.id }))
    end

    local params = {
        command = command.command,
        arguments = command.arguments,
        workDoneToken = command.workDoneToken,
    }
    client.request('workspace/executeCommand', params, function(err, r)
        -- vim.notify('gopls executeCommand' .. vim.inspect(params) .. vim.inspect(err) .. vim.inspect(r), vim.log.levels.INFO)
    end, bufnr)
end


-- CodeActionCommand
-- FillStruct      = "fill_struct"
-- UndeclaredName  = "undeclared_name"
-- ExtractVariable = "extract_variable"
-- ExtractFunction = "extract_function"
-- ExtractMethod   = "extract_method"

-- CodeActionKind
--- ""                          # Empty
--- "quickfix"                  # QuickFix
--- "refactor"                  # Refactor
--- "refactor.extract"          # RefactorExtract
--- "refactor.inline"           # RefactorInline
--- "refactor.rewrite"          # RefactorRewrite
--- "source"                    # Source
--- "source.organizeImports"    # SourceOrganizeImports
--- "source.fixAll"             # SourceFixAll

-- codeaction('', 'source.organizeImports')
-- codeaction('apply_fix', 'refactor.rewrite')
local function code_action(command, only)
    local clients = vim.lsp.get_clients({ name = 'gopls', bufnr = vim.api.nvim_get_current_buf(), })
    if #clients == 0 then
        vim.notify('gopls client not attached, nothing can do', vim.log.levels.INFO)
        return
    end
    local client = clients[1]

    local params = vim.lsp.util.make_range_params()
    if command ~= '' and not command:find('gopls') then
        command = 'gopls.' .. command
    end
    if only then
        params.context = { only = { only } }
    end
    local bufnr = vim.api.nvim_get_current_buf()

    local function ca_hdlr(err, result, hdl_ctx, config)
        if err or not result or next(result) == nil then
            return
        end

        local cmd_actions = {}
        for _, res in pairs(result) do
            if res.edit or res.command then
                return apply_action(client, bufnr, res)
            end

            local act_cmd = res.data and res.data.command or ''
            if act_cmd == command then
                table.insert(cmd_actions, res)
            end
        end

        if #cmd_actions == 0 then
            vim.notify('no cmd_actions available', vim.log.levels.INFO)
            return
        end

        local action = cmd_actions[1]
        -- resolve cmd edit action
        client.request('codeAction/resolve', action, function(_err, resolved_acrtion, ctx, config)
            if _err then
                vim.notify("resove fail" .. vim.inspect(err))
                return
            end
            return apply_action(client, bufnr, resolved_acrtion)
        end, bufnr)
    end

    client.request('textDocument/codeAction', params, ca_hdlr, bufnr)
end

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
local function run_specific_code_action(action_kind, filterFn)
    local opts = {
        apply = true,
        context = {
            only = { action_kind }
        },
        filter = filterFn,
    }

    if vim.api.nvim_get_mode().mode ~= 'v' then
        vim.lsp.buf.code_action(opts)
    else
        vim.lsp.buf.range_code_action(opts)
    end
end

vim.api.nvim_create_autocmd({ "BufWritePre" }, {
    pattern = "*.go",
    callback = function()
        run_specific_code_action("source.organizeImports", nil)
        vim.lsp.buf.format({ async = false })
    end
})

M = {}
M.setup_opts = {
    settings = {
        gopls = {
            gofumpt = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
        },
    },
}

-- /*first arg client is ignored */
M.on_attach = function(_, bufnr)
    local opts = { noremap = true, silent = true }
    local keymap = vim.api.nvim_buf_set_keymap

    vim.api.nvim_buf_create_user_command(bufnr, "GoImports", function()
        -- code_action("", "source.organizeImports")
        run_specific_code_action("source.organizeImports", nil)
    end, {})

    vim.api.nvim_buf_create_user_command(bufnr, "GoFillStruct", function()
        -- code_action("apply_fix", "refactor.rewrite")
        run_specific_code_action("refactor.rewrite", nil)
    end, {})

    vim.api.nvim_buf_create_user_command(bufnr, "GoExtractMethod", function()
        -- code_action("", "refactor.extract")
        run_specific_code_action("refactor.extract", nil)
    end, {})

    keymap(bufnr, "i", ",f", "<cmd>:GoFillStruct<cr>", opts)
end


return M
