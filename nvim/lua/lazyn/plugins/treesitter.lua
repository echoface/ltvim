return {
    "nvim-treesitter/nvim-treesitter",
    event = "VeryLazy",
    build = ":TSUpdate",
    dependencies = {
        { "nvim-treesitter/nvim-treesitter-textobjects" }, -- Syntax aware text-objects
        {
            "nvim-treesitter/nvim-treesitter-context",     -- Show code context
            opts = { enable = true, mode = "topline", line_numbers = true }
        }
    },
    config = function()
        vim.opt.foldmethod = "expr" -- 在treesitter 安装的情况下,使用treesitter的折叠
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"

        local treesitter = require("nvim-treesitter.configs")

        vim.api.nvim_create_autocmd("FileType", {
            pattern = { "markdown" },
            callback = function() -- function(ev)
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
                disable = { "css" } -- preferring chrisbra/csv.vim
            },
            textobjects = { select = { enable = true, lookahead = true } },
            indent = {
                enable = true,
                disable = { "python", "css", "go" } -- go's indent has mistake for 'switch' case
            },
        })
    end
}
