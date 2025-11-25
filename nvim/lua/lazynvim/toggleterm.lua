

return {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
        require("toggleterm").setup({
            direction = 'float',
            persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
            start_in_insert = true,
            float_opts = {
                border = {"", "", "", "", "", "_", "", ""},
                width = vim.o.columns, -- Adjust the width
                height = math.floor(vim.o.lines * 0.45),  -- Adjust the height
                row = 0,
                -- winblend = 2, -- Transparency
            },
            on_open = function(term)
                vim.cmd("startinsert!")
                -- vim.keymap.set("t", "<Esc>", function() term:toggle() end, { buffer = 0 })
            end,
        })
    end
}

