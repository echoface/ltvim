local status_ok, bufferline = pcall(require, "bufferline")
if not status_ok then
  return
end

-- Close buffers
local opts = { silent = true }
vim.keymap.set("n", "<S-q>", "<cmd>Bdelete!<CR>", opts)

bufferline.setup {
  options = {
    close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
    right_mouse_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
    offsets = {
      { filetype = "alpha", text = "", padding = 1 },
      { filetype = "neo-tree", text = "", padding = 1 },
      { filetype = "NvimTree", text = "", padding = 1 },
    },
    separator_style = "thin", -- | "thick" | "thin" | { 'any', 'any' },
  },
}
