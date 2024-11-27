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

local format_util = require("config.util.formating")

M = {
    setup_opts = {
        settings = {
            gopls = {
                gofumpt = true,
                usePlaceholders = false,
                hoverKind = "NoDocumentation",
                directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
            },
        },
    },
    on_attach = function(client, bufnr)
        local opts = { noremap = true, silent = true }
        local keymap = vim.api.nvim_buf_set_keymap

        vim.api.nvim_buf_create_user_command(bufnr, "GoImports", function()
            run_specific_code_action("source.organizeImports")
        end, {})

        keymap(bufnr, "i", ",f", "<cmd>:GoFillStruct<cr>", opts)
        vim.api.nvim_buf_create_user_command(bufnr, "GoFillStruct", function()
            run_specific_code_action("refactor.rewrite")
        end, {})

        -- client.server_capabilities.documentFormattingProvider = false
        format_util.enbale_format_on_write(client, bufnr)
    end
}

return M
