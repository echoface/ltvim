-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }



-- jump to text in current line
keymap("n", "<leader><leader>h", "<Plug>(easymotion-linebackward)", opts)
keymap("n", "<leader><leader>l", "<Plug>(easymotion-lineforward)", opts)
