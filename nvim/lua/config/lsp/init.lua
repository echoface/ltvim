require("lspconfig")
require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = {},
    automatic_enable = {
        exclude = {
            "ts_ls"
        }
    },
})

local lsphandler = require("config.lsp.handlers")
local lsp_signature = require("lsp_signature")

vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('my.lsp', {}),
    callback = function(args)
        local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
        -- Usually not needed if server supports "textDocument/willSaveWaitUntil".
        if not client:supports_method('textDocument/willSaveWaitUntil')
            and client:supports_method('textDocument/formatting') then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = vim.api.nvim_create_augroup('ltvim.lsp', { clear = false }),
                buffer = args.buf,
                callback = function()
                    vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
                end,
            })
        end

        lsp_signature.on_attach({
            bind = true,
            debug = false,
            hint_enable = false,    -- virtual hint
            floating_window = true, -- show hint in a floating window, false for virtual text only mode
            floating_window_above_cur_line = true,
        }, args.buf)

        lsphandler.on_attach(client, args.buf)
    end,
})


local formater = require("config.util.formating")
formater.setup({
    idlfmt_ftypes = { "*.go", "*.py", "*.c", "*.cpp", "*.lua", "*.yaml" },
})

local nullls_ok, null_ls = pcall(require, "null-ls")
if nullls_ok then
    null_ls.setup {
        debug = false,
        sources = {
            -- formating
            null_ls.builtins.formatting.prettier.with {
                filetypes = { "markdown" },
                extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
            },
            -- formating
            null_ls.builtins.formatting.gofumpt,
            -- null_ls.builtins.formatting.goimports,
            --
            -- completion
            -- null_ls.builtins.completion.spell,
            -- null_ls.builtins.completion.luasnip,
            -- null_ls.builtins.completion.nvim_snippets,
            --
            -- code action
            null_ls.builtins.code_actions.gitsigns,
            null_ls.builtins.code_actions.textlint, -- { "text", "markdown" }
            null_ls.builtins.code_actions.impl,
            null_ls.builtins.code_actions.refactoring,
            null_ls.builtins.code_actions.gomodifytags, --go
        },
    }
    local ok, mason_null = pcall(require, "mason-null-ls")
    if ok then
        mason_null.setup({
            ensure_installed = {},
            automatic_installation = false,
        })
    end
end
