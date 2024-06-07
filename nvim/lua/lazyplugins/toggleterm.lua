return {
    "akinsho/toggleterm.nvim",
    version = '*',
    event = "VeryLazy",
    config = function()
        require("config.toggleterm")
    end,
}
