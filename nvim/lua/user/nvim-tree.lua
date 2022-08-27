local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  return
end

local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
if not config_status_ok then
  return
end

local tree_cb = nvim_tree_config.nvim_tree_callback
vim.api.nvim_set_keymap("n", "<leader>ts", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
-- exit vim when only nvimtree buffer
vim.cmd "autocmd BufEnter * ++nested if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif"


nvim_tree.setup {
  update_focused_file = {
    enable = false,
    update_cwd = true,
  },
  renderer = {
    root_folder_modifier = ":t",
    icons = {
      show = {
        git = false,
        file = false,
        folder = false,
      },
    },
  },
  diagnostics = {
    enable = true,
    show_on_dirs = false,
    icons = {
      hint = "h",
      info = "i",
      warning = "w",
      error = "x",
    },
  },
  view = {
    width = 30,
    height = 30,
    side = "left",
    adaptive_size = true,
    mappings = {
      list = {
        { key = { "l", "<CR>", "o" }, cb = tree_cb "edit" },
        { key = "h", cb = tree_cb "close_node" },
        { key = "v", cb = tree_cb "vsplit" },
      },
    },
  },
}
