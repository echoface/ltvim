return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        preset = "modern", -- "helix", "classic", "modern"
        -- triggers = {
        --     { "<auto>", mode = "nixsotc" },
        -- },
        delay = function(ctx)
            return ctx.plugin and 0 or 1000
        end,
        win = {
            zindex = 50
        },
        -- layout = {
        --     height = { min = 2, max = 12 },
        --     width = { min = 20, max = 60 },
        --     spacing = 4,
        --     align = "center",
        -- },
    },
    -- config = function()
    --     -- vim.api.nvim_set_hl(0, "WhichKeyFloat", { bg = "none" })
    --     -- vim.api.nvim_set_hl(0, "WhichKey", { fg = "#a9b1d6" })
    --     -- vim.api.nvim_set_hl(0, "WhichKeyGroup", { fg = "#7aa2f7" })
    --     -- vim.api.nvim_set_hl(0, "WhichKeyDesc", { fg = "#c0caf5" })
    -- end,
    keys = {
        {
            "<leader>?",
            function()
                require("which-key").show({ global = false })
            end,
            desc = "Buffer Local Keymaps (which-key)",
        },
    },
}
