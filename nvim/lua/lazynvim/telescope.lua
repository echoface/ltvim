return {
    "nvim-telescope/telescope.nvim",
    version = '*',
    event = "VeryLazy",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "ahmedkhalf/project.nvim" },
        { "nvim-telescope/telescope-ui-select.nvim" },
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
    },
    config = function()
        require("config.project")
        require("config.telescope")
    end
}
