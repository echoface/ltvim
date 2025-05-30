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
        context = { only = { action_kind } },
    }
    vim.lsp.buf.code_action(opts)
end


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

M = {
    setup_opts = {
        settings = {
            -- full setting can be found: gopls api-json
            gopls = {
                gofumpt = true, -- more strict format
                usePlaceholders = false,
                completeFunctionCalls = true,
                hoverKind = "NoDocumentation",
                directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                codelenses = {
                    tidy = false,
                    vendor = false,
                    gc_details = false,
                    generate = false,
                    regenerate_cgo = false,
                    run_govulncheck = false,
                    upgrade_dependency = true,
                },
                diagnosticsTrigger = "Save" -- Save,Edit
            },
        },
    },
    on_attach = function(client, bufnr)
        create_cmd_goimports(bufnr)
        create_cmd_fill_struct(bufnr)

        local opts = { noremap = true, silent = true }
        local keymap = vim.api.nvim_buf_set_keymap
        keymap(bufnr, "i", ",f", "<cmd>:GoFillStruct<cr>", opts)

        format_util.enable_format_on_write(client, bufnr)
        -- client.server_capabilities.documentFormattingProvider = false
    end
}

return M
