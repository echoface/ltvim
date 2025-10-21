return {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
        require("toggleterm").setup({
            direction = 'tab',
            on_open = function(term)
                -- vim.cmd("startinsert!")
                vim.api.nvim_buf_set_name(term.bufnr, "Terminal #" .. term.id)
            end,
        })
        vim.keymap.set("n", "tt", [[<Cmd>:ToggleTerm"<CR>]], { noremap = true, silent = true })
    end
}
