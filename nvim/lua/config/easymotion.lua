-- Shorten function name
--
-- ,,w: 跳转到当前光标后的位置(ward)
-- ,,b: 跳转到当前光标前的位置(backward)

vim.cmd [[

let g:EasyMotion_smartcase = 1
"let g:EasyMotion_startofline = 0 " keep cursor colum when JK motion
map <Leader><leader>h <Plug>(easymotion-linebackward)
map <Leader><Leader>j <Plug>(easymotion-j)
map <Leader><Leader>k <Plug>(easymotion-k)
map <Leader><leader>l <Plug>(easymotion-lineforward)
" 重复上一次操作, 类似repeat插件, 很强大
map <Leader><leader>. <Plug>(easymotion-repeat)
]]

-- local keymap = vim.keymap.set
-- local opts = { silent = true }
-- keymap("n", "<leader><leader>h", "<Plug>(easymotion-linebackward)", opts)
-- keymap("n", "<leader><leader>l", "<Plug>(easymotion-lineforward)", opts)
