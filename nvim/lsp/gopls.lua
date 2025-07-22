---@diagnostic disable: missing-fields

local format_util = require("config.util.formating")

local create_cmd_fill_struct = function(bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "GoFillStruct", function()
        vim.lsp.buf.code_action({
            apply = true,
            context = { only = { "refactor.rewrite" } },
        })
    end, {})
end

local create_cmd_goimports = function(bufnr)
    vim.api.nvim_buf_create_user_command(bufnr, "GoImports", function()
        vim.lsp.buf.code_action({
            apply = true,
            context = { only = { "source.organizeImports" } },
        })
    end, {})
end

return {
    -- cmd = { "gopls", "-rpc.trace", "-logfile", "/tmp/gopls.log" },
    root_markers = { 'go.mod', 'go.work', '.git' },
    -- capabilities = {
    --   workspace = {
    --     didChangeWatchedFiles = { dynamicRegistration = false },
    --   },
    -- },
    settings = {
        gopls = {
            gofumpt = true,
            codelenses = {
                test = false,
                tidy = false,
                vendor = false,
                generate = true,
                gc_details = false,
                regenerate_cgo = false,
                run_govulncheck = false,
                upgrade_dependency = false,
            },
            hints = {
                constantValues = true,
                parameterNames = false,
                assignVariableTypes = true,
                compositeLiteralFields = true,
                functionTypeParameters = false,
                compositeLiteralTypes = false,
                rangeVariableTypes = true,
            },
            analyses = {
                useany = false,
                nilness = false,
                unusedparams = false,
                unusedwrite = false,
            },
            staticcheck = false,
            semanticTokens = false,
            diagnosticsDelay = "5s",
            diagnosticsTrigger = "Save", -- Edit/Save
            usePlaceholders = false,
            completeUnimported = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
        }
    },
    on_attach = function(client, bufnr)
        create_cmd_goimports(bufnr)
        create_cmd_fill_struct(bufnr)

        local opts = { noremap = true, silent = true }
        local keymap = vim.api.nvim_buf_set_keymap
        keymap(bufnr, "i", ",f", "<cmd>:GoFillStruct<cr>", opts)

        format_util.enable_format_on_write(client, bufnr)
    end,
}
