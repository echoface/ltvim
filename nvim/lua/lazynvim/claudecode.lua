return {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    config = true,
    opts = {
        terminal = {
            snacks_win_opts = {
                position = "bottom",
                height = 0.4,
                width = 1.0,
                border = "none",
                keys = {
                    -- claude_close = { "q", "close", mode = "n", desc = "Close" }, -- conflict
                    claude_close = { "q", function(self) self:hide() end, mode = "n", desc = "Hide" },
                    claude_hide = { "<leader>tc", function(self) self:hide() end, mode = "t", desc = "Hide", },
                },
            },
        },
    },
    keys = {
        { "<leader>tc", "<cmd>ClaudeCode<cr>",            desc = "Toggle Claude",      mode = { "n", "x" } },
        { "<leader>cr", "<cmd>ClaudeCode --resume<cr>",   desc = "Resume Claude" },
        { "<leader>cc", "<cmd>ClaudeCode --continue<cr>", desc = "Continue Claude" },
        { "<leader>cm", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },

        { "<leader>cb", "<cmd>ClaudeCodeAdd %<cr>",       desc = "Add current buffer" },
        { "<leader>cs", "<cmd>ClaudeCodeSend<cr>",        mode = "v",                  desc = "Send to Claude" },
        {
            "<leader>ca",
            "<cmd>ClaudeCodeTreeAdd<cr>",
            desc = "Add file",
            ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
        },
        -- Diff management
        { "<leader>cn", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept new code" },
        { "<leader>co", "<cmd>ClaudeCodeDiffDeny<cr>",   desc = "Deny new code" },
    },
}
