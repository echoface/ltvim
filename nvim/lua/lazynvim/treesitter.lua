return {
    "nvim-treesitter/nvim-treesitter",
    version = '*',
    event = "VeryLazy",
    build = ":TSUpdate",
    config = function()
        require("config.treesitter")
    end
}
