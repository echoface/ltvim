local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local evloop = vim.uv or vim.loop
if not evloop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git", "--branch=stable", -- latest stable release
        lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { import = "lazyplugins" },

        -- other simple enough plugin
        { "moll/vim-bbye",                  event = "VeryLazy" },
        { "APZelos/blamer.nvim",            event = "VeryLazy" },
        { "easymotion/vim-easymotion",      event = "VeryLazy" },
        { "ntpeters/vim-better-whitespace", event = "VeryLazy" },
        {
            "rcarriga/nvim-notify",
            config = function()
                vim.notify = require("notify")
            end
        },
        {
            "morhetz/gruvbox",
            --"tanvirtin/monokai.nvim",
            priority = 1000,
            config = function()
                vim.cmd.colorscheme('gruvbox')
            end
        },
    },
    ui = { border = "rounded" },
    checker = { enabled = false }, -- automatically check for plugin updates
})
