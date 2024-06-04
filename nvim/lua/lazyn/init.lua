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
        { import = "lazyn.plugins" },

        -- other simple enough plugin
        { "moll/vim-bbye", event = "VeryLazy" },
        { "APZelos/blamer.nvim", event = "VeryLazy" },
        { "ntpeters/vim-better-whitespace", ft = {"c","cpp"}},
        {
            "rcarriga/nvim-notify",
            priority = 999,
            config = function()
                vim.notify = require("notify")
            end
        },
        {
            "tanvirtin/monokai.nvim",
            priority = 999,
            config = function()
                vim.cmd.colorscheme('monokai')
            end
        },
        {
            "easymotion/vim-easymotion",
            event = "VeryLazy",
            config = function()
                local opts = { silent = true }
                local keymap = vim.keymap.set
                keymap("n", "<leader><leader>l", "<Plug>(easymotion-lineforward)", opts)
                keymap("n", "<leader><leader>h", "<Plug>(easymotion-linebackward)", opts)
            end
        },
    },
    ui = {border = "rounded"},
    checker = { enabled = false },          -- automatically check for plugin updates
    change_detection = { enabled = true }, -- disable check for config file changes
})
