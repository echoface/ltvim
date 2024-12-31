return {
    "nvim-lualine/lualine.nvim",
    -- event = { "BufEnter" },
    event = "VeryLazy",
    dependencies = {
        { "nvim-tree/nvim-web-devicons" },
        {
            'linrongbin16/lsp-progress.nvim',
            config = function() require('lsp-progress').setup() end
        }
    },
    config = function()
        require("config.lualine")
    end
}
