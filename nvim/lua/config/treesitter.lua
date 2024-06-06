local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return
end

vim.opt.foldmethod = "expr" -- 在treesitter 安装的情况下,使用treesitter的折叠
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"


vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown" },
    callback = function()         -- function(ev)
        -- treesitter-context is buggy with Markdown files
        require("treesitter-context").disable()
    end
})

treesitter.setup({
    ignore_install = {},
    ensure_installed = {
        "c", "cpp", "lua", "python", "go", "proto",
        "bash", "json", "vim", "markdown", "comment",
        "lua", "markdown", "proto", "python", "yaml",
        "gomod", "gosum", "gowork", "javascript", "json",
    },
    modules = {},
    auto_install = true,
    sync_install = false,
    highlight = {
        enable = true,
        disable = { "css" }         -- preferring chrisbra/csv.vim
    },
    autopairs = {
        enable = true,
    },
    textobjects = { select = { enable = true, lookahead = true } },
    indent = {
        enable = true,
        disable = { "python", "css", "go" }         -- go's indent has mistake for 'switch' case
    },
})
