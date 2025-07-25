vim.opt.backup = false                                     -- creates a backup file
vim.opt.hidden = true
vim.opt.clipboard = "unnamedplus"                          -- allows neovim to access the system clipboard
vim.opt.cmdheight = 1                                      -- more space in the neovim command line for displaying messages
vim.opt.completeopt = { "menuone", "preview", "noselect" } -- mostly just for cmp
vim.opt.conceallevel = 0                                   -- so that `` is visible in markdown files
vim.opt.fileencoding = "utf-8"                             -- the encoding written to a file
vim.opt.hlsearch = true                                    -- highlight all matches on previous search pattern
vim.opt.ignorecase = true                                  -- ignore case in search patterns
vim.opt.mouse = ""                                         -- allow the mouse to be used in neovim
vim.opt.pumheight = 10                                     -- pop up menu height
vim.opt.showmode = false                                   -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 0                                    -- always show tabs
vim.opt.smartcase = true                                   -- smart case
vim.opt.smartindent = true                                 -- make indenting smarter again
vim.opt.splitbelow = true                                  -- force all horizontal splits to go below current window
vim.opt.splitright = true                                  -- force all vertical splits to go to the right of current window
vim.opt.swapfile = false                                   -- creates a swapfile
vim.opt.termguicolors = true                               -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 1000                                  -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true                                    -- enable persistent undo
vim.opt.updatetime = 1000                                  -- faster completion (4000ms default)
vim.opt.writebackup = false                                -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.smarttab = true                                    -- tab behavior
vim.opt.expandtab = true                                   -- convert tabs to spaces
vim.opt.tabstop = 4                                        -- insert 4 spaces for a tab
vim.opt.softtabstop = 4                                    -- <tab> count number for eidting
vim.opt.shiftwidth = 4                                     -- the number of spaces inserted for each indentation
vim.opt.cursorline = true                                  -- highlight the current line
vim.opt.number = true                                      -- set numbered lines
vim.opt.laststatus = 3
vim.opt.showcmd = false
vim.opt.ruler = false
vim.opt.numberwidth = 4     -- set number column width to 2 {default 4}
vim.opt.signcolumn = "yes"  -- always show the sign column, otherwise it would shift the text each time
vim.opt.wrap = false        -- display lines as one long line
vim.opt.scrolloff = 8       -- is one of my fav
vim.opt.sidescrolloff = 8
vim.opt.startofline = false -- don't jump to startofline for g,G,<C-jumpcmd>
-- c:不会自动在注释行过长时换行
-- r: 在注释行中按回车键时，不会自动在新行插入注释标记
-- t:在普通模式下使用 o 或 O 命令新增行时，不会自动延续注释
vim.cmd("set formatoptions-=cro")

-- vim.opt.virtualedit = "all"                     -- keep curosr in fixed column
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


-- za: foldtoggle   zo: fold open  zc: fold close
vim.opt.foldmethod = "indent" -- 设置语法折叠
vim.opt.foldlevelstart = 10   -- don't fold any thing when open file

-- vim.lsp.set_log_level 'debug'
-- require('vim.lsp.log').set_format_func(vim.inspect)
