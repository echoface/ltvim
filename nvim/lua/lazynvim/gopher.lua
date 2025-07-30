return {
    "olexsmir/gopher.nvim",
    ft = "go",
    enabled = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        -- "mfussenegger/nvim-dap", -- (optional) only if you use `gopher.dap`
        "nvim-treesitter/nvim-treesitter",
    },
    -- (optional) will update plugin's deps on every update
    -- build = function()
    --   vim.cmd.GoInstallDeps()
    -- end,
    ---@type gopher.Config
    opts = {},
}
