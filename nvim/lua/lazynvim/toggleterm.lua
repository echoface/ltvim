
return {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
        require("toggleterm").setup({
            direction = 'float',
            persist_mode = false, -- 每次重新打开都回到默认模式，而不是记住上次的 normal/insert 状态
            start_in_insert = true,
            on_open = function(_)
                vim.cmd("startinsert!")
            end,
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
