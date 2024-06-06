return {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    dependencies = {"nvim-treesitter/nvim-treesitter"},
    config = function() require("Comment").setup() end
}
