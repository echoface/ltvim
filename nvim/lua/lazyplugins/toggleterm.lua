return {
    'akinsho/toggleterm.nvim',
    version = "*",
    config = function()
        require("toggleterm").setup()
        vim.api.nvim_create_user_command("TabTerm", function()
            vim.cmd [[
            ToggleTerm direction="tab"<CR>
            ]]
        end, {})
        vim.keymap.set("n", "tf", [[<Cmd>:ToggleTerm direction="tab"<CR>]], { noremap = true, silent = true })
    end
}
