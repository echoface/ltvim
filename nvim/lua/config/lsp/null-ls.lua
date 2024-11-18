local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then return end

null_ls.setup {
    debug = false,
    sources = {
        -- formating
        null_ls.builtins.formatting.prettier.with {
            filetypes = { "markdown" },
            extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" },
        },
        null_ls.builtins.formatting.gofumpt,
        null_ls.builtins.formatting.goimports,
        -- completion
        -- null_ls.builtins.completion.spell,
        -- code action
        null_ls.builtins.code_actions.impl,
        null_ls.builtins.code_actions.refactoring,
        null_ls.builtins.code_actions.gomodifytags, --go
    },
}

require("mason-null-ls").setup({
    ensure_installed = {},
    automatic_installation = false,
})
