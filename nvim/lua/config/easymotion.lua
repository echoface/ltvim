-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }


-- jump to {keywords} aka: search
-- <leader><leader>s

-- jump a text in formward / backward
-- <leader><leader>w(即,,w)和<leader><leader>b(即,,b)

-- jump to line
-- map <Leader><Leader>j <Plug>(easymotion-j)
-- map <Leader><Leader>k <Plug>(easymotion-k)

-- jump to text in current line
keymap("n", "<leader><leader>h", "<Plug>(easymotion-linebackward)", opts)
keymap("n", "<leader><leader>l", "<Plug>(easymotion-lineforward)", opts)
