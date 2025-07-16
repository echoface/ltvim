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
    -- Example: Override capabilities (ensure your LSP client supports this)
    -- capabilities = {
    --   workspace = {
    --     didChangeWatchedFiles = { dynamicRegistration = false },
    --   },
    -- },
    settings = {
        gopls =
        {
            gofumpt = true,
            codelenses = {
                gc_details = false,
                regenerate_cgo = true,
                generate = true,
                run_govulncheck = true,
                test = true,
                tidy = true,
                upgrade_dependency = true,
                vendor = true,
            },
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                constantValues = true,
                functionTypeParameters = true,
                compositeLiteralTypes = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
            analyses = {
                nilness = true,
                unusedparams = true,
                unusedwrite = true,
                useany = true,
            },
            diagnosticsDelay = "5s",
            diagnosticsTrigger = "Save", -- Edit/Save
            usePlaceholders = true,
            completeUnimported = true,
            staticcheck = true,
            directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            semanticTokens = true,
        }
    },
    -- Example: Add a custom on_attach specifically for gopls
    on_attach = function(client, bufnr)
        vim.notify("Attaching gopls with custom settings!", vim.log.levels.INFO)
        -- Add gopls-specific keymaps or logic here
        create_cmd_goimports(bufnr)
        create_cmd_fill_struct(bufnr)

        local opts = { noremap = true, silent = true }
        local keymap = vim.api.nvim_buf_set_keymap
        keymap(bufnr, "i", ",f", "<cmd>:GoFillStruct<cr>", opts)

        format_util.enable_format_on_write(client, bufnr)
    end,
}
