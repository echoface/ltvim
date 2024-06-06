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
        require("config.treesitter")
    end
}
