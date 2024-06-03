M = {}
M.setup_opts = {
    on_init = function(client)
        local path = client.workspace_folders[1].name
        if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            return
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                }
            }
        })
    end,
    settings = {
        gopls = {
            gofumpt = true,
            codelenses = {
                test = true,
                tidy = true,
                generate = true,
                vendor = false,
                gc_details = false,
                regenerate_cgo = true,
                run_govulncheck = true,
                upgrade_dependency = true,
            },
            hints = {
                constantValues = true,
                parameterNames = true,
                rangeVariableTypes = true,
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                functionTypeParameters = true,
            },
            analyses = {
                useany = true,
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                fieldalignment = true,
            },
            staticcheck = true,
            semanticTokens = true,
            usePlaceholders = true,
            completeUnimported = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
        },
    },
}

local function organize_imports()
    --vim.lsp.buf.code_action({
    --    apply = true,
    --    context = {only = { "source.organizeImports" }},
    --})
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

    -- 'refactor.rewrite', 'fill_struct'
    -- vim.cmd('command! GoFillStruct lua vim.lsp.buf.code_action()<cr>')
    -- vim.cmd('command! GoImplements lua vim.lsp.buf.implementation()<cr>')

    vim.api.nvim_buf_create_user_command(bufnr, "GoImports", organize_imports, {})
    vim.api.nvim_buf_create_user_command(bufnr, "GoFillStruct", function()
        vim.lsp.buf.code_action({
            apply = true,
            context = { only = { "refactor.rewrite" } },
        })
    end, {})
end

return M
