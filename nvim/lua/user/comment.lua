local status_ok, comment = pcall(require, "Comment")
if not status_ok then return end


comment.setup()

-- Comment
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }
keymap("n", "<leader>/", "<cmd>lua require('Comment.api').toggle_current_linewise()<CR>", opts)
keymap("x", "<leader>/", '<ESC><CMD>lua require("Comment.api").toggle_linewise_op(vim.fn.visualmode())<CR>')
