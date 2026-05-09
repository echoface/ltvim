
return {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
        require("toggleterm").setup({
            direction = 'float',
            persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
            start_in_insert = true,
            float_opts = {
                -- width = vim.o.columns, -- Adjust the width
                -- height = math.floor(vim.o.lines * 0.6),  -- Adjust the height
                -- row = 1 -- vim.o.lines - math.floor(vim.o.lines * 0.6) - 4,
                -- row = 1 -- vim.o.lines - math.floor(vim.o.lines * 0.6) - 4,
                row = 0,
                col = 0,
                width = vim.o.columns,
                height = vim.o.lines - 4,
            },
        })
        vim.keymap.set({"n"}, "tt", "<cmd>ToggleTerm<CR>", { desc = "Toggle terminal" })
    end
}

