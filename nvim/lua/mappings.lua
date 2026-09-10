-- 插件无关的基础键mapping --

vim.g.mapleader = ","

-- Modes
--   term_mode = "t",
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   command_mode = "c",
--   visual_block_mode = "x",

-- Silent keymap option
local opts = { noremap = true, silent = true }

-- Shorten function name
local keymap = vim.keymap.set

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)
keymap("n", "<leader>ww", "<C-w>w", opts)
keymap("n", "<leader>wh", "<C-w>h", opts)
keymap("n", "<leader>wj", "<C-w>j", opts)
keymap("n", "<leader>wk", "<C-w>k", opts)
keymap("n", "<leader>wl", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "+", ":res +5<CR>", opts)
keymap("n", "_", ":res -5<CR>", opts)
keymap("n", "(", ":vertical resize -5<CR>", opts)
keymap("n", ")", ":vertical resize +5<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)
-- Navigate tabs
-- keymap("n", "<C-n>", ":tabn<CR>", opts)

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)


-- Insert --
-- Press jk fast to enter
keymap("i", "jj", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)
-- Better paste
keymap("v", "p", '"_dP', opts)


-- 不要设置 clipboard=unnamedplus，保持默认
-- vim.opt.clipboard = ''   -- 确保是空的（默认即可）

-- 系统剪贴板复制函数（优先 OSC 52，适合远程 + tmux）
local function copy_to_system_clipboard()
  -- 拿到当前 visual 选中的内容
  local mode = vim.fn.mode()
  if mode ~= 'v' and mode ~= 'V' and mode ~= '\22' then  -- \22 = Ctrl-V 块选
    return
  end

  -- 用 OSC 52 发到本地系统剪贴板（远程/SSH 也能用）
  local osc52 = require('vim.ui.clipboard.osc52')
  local lines = vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.'), { type = mode })
  osc52.copy('+')(lines)

  -- 可选：同时放进 + 寄存器，方便后续 "+p
  vim.fn.setreg('+', table.concat(lines, '\n'), mode == 'V' and 'V' or 'v')

  -- 退出 visual 模式（可选，看个人习惯）
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'n', false)

  vim.notify('已复制到系统剪贴板', vim.log.levels.INFO, { title = 'Clipboard' })
end

-- Visual 模式下绑定
keymap('x', '<D-c>', copy_to_system_clipboard, { desc = 'Copy selection to system clipboard (macOS)' })
keymap('x', '<C-c>', copy_to_system_clipboard, { desc = 'Copy selection to system clipboard (Windows/Linux)' })
