local nullls_ok, null_ls = pcall(require, "null-ls")
if not nullls_ok then
    return
end

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
