return {
    "kyazdani42/nvim-tree.lua",
    version = '*',
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("config.nvimtree")
    end
}
