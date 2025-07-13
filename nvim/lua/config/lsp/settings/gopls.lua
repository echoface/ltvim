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

-- full setting can be found by execute: `gopls api-json`
M = {
    on_attach = function(client, bufnr)
        create_cmd_goimports(bufnr)
        create_cmd_fill_struct(bufnr)

        local opts = { noremap = true, silent = true }
        local keymap = vim.api.nvim_buf_set_keymap
        keymap(bufnr, "i", ",f", "<cmd>:GoFillStruct<cr>", opts)

        format_util.enable_format_on_write(client, bufnr)

        -- override config
        -- Server-specific settings. See `:help lsp-quickstart`
        -- vim.lsp.config('gopls', {
        --     settings = {
        --         ['gopls'] = {},
        --     },
        -- })
    end
}

return M
