return {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    dependencies = {
        { "nvim-lua/plenary.nvim" },
        { "ahmedkhalf/project.nvim" },
        { "nvim-telescope/telescope-ui-select.nvim" },
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            enabled = true
        },
    },
    tag = "0.1.6",
    config = function()
        require("config.project")
        require("config.telescope")
    end
}
