vim.opt.backup = false                          -- creates a backup file
vim.opt.clipboard = "unnamedplus"               -- allows neovim to access the system clipboard
vim.opt.cmdheight = 1                           -- more space in the neovim command line for displaying messages
vim.opt.completeopt = { "menuone", "preview", "noselect" } -- mostly just for cmp
vim.opt.conceallevel = 0                        -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8"                  -- the encoding written to a file
vim.opt.hlsearch = true                         -- highlight all matches on previous search pattern
vim.opt.ignorecase = true                       -- ignore case in search patterns
vim.opt.mouse = ""                              -- allow the mouse to be used in neovim
vim.opt.pumheight = 10                          -- pop up menu height
vim.opt.showmode = false                        -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 0                         -- always show tabs
vim.opt.smartcase = true                        -- smart case
vim.opt.smartindent = true                      -- make indenting smarter again
vim.opt.splitbelow = true                       -- force all horizontal splits to go below current window
vim.opt.splitright = true                       -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false                        -- creates a swapfile
vim.opt.termguicolors = true                    -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 1000                       -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true                         -- enable persistent undo
vim.opt.updatetime = 1000                       -- faster completion (4000ms default)
vim.opt.writebackup = false                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.smarttab = true                         -- tab behavior
vim.opt.expandtab = true                        -- convert tabs to spaces
vim.opt.tabstop = 4                             -- insert 4 spaces for a tab
vim.opt.softtabstop = 4                         -- <tab> count number for eidting
vim.opt.shiftwidth = 4                          -- the number of spaces inserted for each indentation
vim.opt.cursorline = true                       -- highlight the current line
vim.opt.number = true                           -- set numbered lines
vim.opt.laststatus = 3
vim.opt.showcmd = false
vim.opt.ruler = false
vim.opt.numberwidth = 4                         -- set number column width to 2 {default 4}
vim.opt.signcolumn = "yes"                      -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false                            -- display lines as one long line
vim.opt.scrolloff = 8                           -- is one of my fav
vim.opt.sidescrolloff = 8
vim.opt.guifont = "monospace:h17"               -- the font used in graphical neovim applications
vim.opt.fillchars.eob=" "
vim.opt.shortmess:append("cF")
vim.opt.whichwrap:append("<,>,[,]")
vim.opt.iskeyword:append("-")
vim.opt.startofline = false                     -- don't jump to startofline for g,G,<C-jumpcmd>
-- vim.opt.virtualedit = "all"                     -- keep curosr in fixed column
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


-- za: foldtoggle   zo: fold open  zc: fold close
vim.opt.foldmethod="syntax"         -- 设置语法折叠
vim.opt.foldlevelstart = 99         -- don't fold any thing when open file

-- colorscheme
-- vim.cmd[[colorscheme tokyonight]]
-- vim.cmd[[colorscheme darkplus]]
-- vim.cmd[[colorscheme dracula]]
-- vim.cmd.colorscheme('sonokai')
vim.cmd.colorscheme('monokai')

-- Use 'q' to quit from common plugins
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "qf", "help", "man", "lspinfo", "spectre_panel", "lir" },
  callback = function()
    vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]]
  end,
})

-- Remove statusline and tabline when in Alpha
vim.api.nvim_create_autocmd({ "User" }, {
  pattern = { "AlphaReady" },
  callback = function()
    vim.cmd [[
      set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
      set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3
    ]]
  end,
})

-- Set wrap and spell in markdown and gitcommit
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Fixes Autocomment
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function()
    vim.cmd "set formatoptions-=cro"
  end,
})

-- vim.cmd [[autocmd! TermOpen term://* lua set_terminal_keymaps()]]
vim.api.nvim_create_autocmd({ "TermOpen" }, {
  callback = function()
    vim.cmd "set nonu"
    vim.cmd "DisableWhitespace"
  end,
})

--vim.g.better_whitespace_filetypes_blacklist={
--    'diff', 'git', 'gitcommit', 'unite', 'qf',
--    'help', 'markdown', 'fugitive', 'alpha'
--}

vim.cmd [[autocmd BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4]]
vim.cmd [[autocmd BufNewFile,BufRead c,cpp setlocal et ts=2 sw=2 sts=2]]

-- back last edit position
vim.cmd [[autocmd BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif]]


-- diagnostics basic(none lsp related) config
local diagnostic_signs = {
    { name = "DiagnosticSignHint", text = "" },
    { name = "DiagnosticSignInfo", text = "" },
    { name = "DiagnosticSignWarn", text = "" },
    { name = "DiagnosticSignError", text = "" },
}

for _, sign in ipairs(diagnostic_signs) do
    vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = "" })
end

vim.diagnostic.config({
    virtual_text = false,                   -- disable virtual text
    update_in_insert = false,               -- update diagnostic edit
    signs = { active = diagnostic_signs, }, -- show signs
    float = {
        focusable = true,
        style = "minimal",
        border = "rounded",
        source = true, -- 'if_many'
    },
})
vim.cmd('command! Diagnostics lua vim.diagnostic.open_float()<cr>')
vim.cmd('command! DiagnosticsPre lua vim.diagnostic.goto_prev({buffer=0})<cr>')
vim.cmd('command! DiagnosticsNext lua vim.diagnostic.goto_next({buffer=0})<cr>')
-- display diagnostics when cursor hold only in normal mode
vim.cmd [[autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focus=false})]]
-- vim.cmd [[autocmd CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]]


-- keymapping
--Remap space as leader key
--vim.g.mapleader = " "
vim.g.mapleader = ","

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Silent keymap option
local opts = { noremap = true, silent = true }


-- Shorten function name
local keymap = vim.keymap.set

keymap("n", "ge", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)

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
keymap("n", "(", ":vertical resize -2<CR>", opts)
keymap("n", ")", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", opts)

-- Better paste
keymap("v", "p", '"_dP', opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)
keymap("i", "jj", "<ESC>", opts)


-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- terminal
keymap('t', '<esc>', [[<C-\><C-n>]], opts)

