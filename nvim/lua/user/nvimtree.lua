local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
	return
end

vim.api.nvim_set_keymap("n", "ts", ":NvimTreeFindFileToggle<CR>", { noremap = true, silent = true })
-- exit vim when only nvimtree buffer
-- vim.cmd "autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif"

nvim_tree.setup({
    git = {
        enable = false,
    },
    diagnostics = {
        enable = true,
    },
    view = {
        side = "right",
        height = "100%",
        mappings = {
            list = {
                { key = "s", action = "vsplit" },
                { key = "C", action = "cd", mode = "n" },
                { key = { "u", "-" }, action = "dir_up" },
                { key = { "o", "e" }, action = "edit", mode = "n" },
            },
        },
    },
    actions = {
        open_file = {quit_on_open = true},
    },
})
