return {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
        require("toggleterm").setup({
            direction = 'horizontal',
            size = function(term)
                return vim.o.lines * 0.8
            end
        })
        vim.api.nvim_create_user_command("TabTerm", function()
            vim.cmd [[
            ToggleTerm direction="horizontal"<CR>
            ]]
        end, {})
        vim.keymap.set("n", "tf", [[<Cmd>:ToggleTerm direction="horizontal"<CR>]], { noremap = true, silent = true })
    end
}
