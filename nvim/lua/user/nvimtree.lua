local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
    return
end

vim.api.nvim_set_keymap("n", "ts", ":NvimTreeFindFileToggle<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "tt", ":NvimTreeFindFileToggle<CR>", { noremap = true, silent = true })
-- exit vim when only nvimtree buffer
-- vim.cmd "autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif"

local function on_attach(bufnr)
  local api = require('nvim-tree.api')

  local function opts(desc)
    return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  api.config.mappings.default_on_attach(bufnr)

  -- You will need to insert "your code goes here" for any mappings with a custom action_cb
  vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 'e', api.node.open.edit, opts('Open'))
  vim.keymap.set('n', 'C', api.tree.change_root_to_node, opts('CD'))
  vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))
  vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts('Up'))
  vim.keymap.set('n', 's', api.node.open.vertical, opts('Open: Vertical Split'))
end

nvim_tree.setup({
    on_attach = on_attach,
    git = {
        enable = false,
    },
    diagnostics = {
        enable = true,
    },
    view = {
        side = "left",
    }
})


