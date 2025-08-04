return {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
        require("toggleterm").setup({
            direction = 'horizontal',
            size = function(_)
                return vim.o.lines * 0.6
            end,
            on_open = function(term)
                -- vim.cmd("startinsert!")
                vim.api.nvim_buf_set_name(term.bufnr, "Terminal #" .. term.id)
            end,
        })
        vim.keymap.set("n", "tf", [[<Cmd>:ToggleTerm direction="horizontal"<CR>]], { noremap = true, silent = true })
    end
}
