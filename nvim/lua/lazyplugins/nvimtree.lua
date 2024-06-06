return {
    "kyazdani42/nvim-tree.lua",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("config/nvimtree")
    end
}
