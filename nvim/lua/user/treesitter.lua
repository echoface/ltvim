local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return
end

vim.opt.foldmethod = "expr"                     -- 在treesitter 安装的情况下,使用treesitter的折叠 
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

configs.setup({
    ensure_installed = {
        "c", "cpp", "lua", "python", "go", "proto",
        "bash", "json", "vim", "markdown", "comment"
    }, -- one of "all" or a list of languages
    ignore_install = { "css", 'help' }, -- List of parsers to ignore installing
    highlight = {
        enable = true, -- false will disable the whole extension
        disable = { "css" }, -- list of language that will be disabled
    },
    autopairs = {
        enable = true,
    },
    indent = {
        enable = true,
        disable = { "python", "css", "go" } -- go's indent has mistake for 'switch' case
    },
})
