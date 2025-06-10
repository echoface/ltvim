local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
local evloop = vim.uv or vim.loop
if not evloop.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    spec = {
        { import = "lazynvim" },
    },
    ui = { border = "rounded" },
    checker = { enabled = false }, -- automatically check for plugin updates
    performance = {
        rtp = {
            disabled_plugins = { "gzip", "tutor", "tohtml", "tarPlugin", "zipPlugin", },
        },
    },
})
