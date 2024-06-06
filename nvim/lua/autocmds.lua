--    README       ---
--  插件无关的设置 ---

-- filetype related
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
-- Set wrap and spell in markdown and gitcommit
vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})
vim.api.nvim_create_autocmd("FileType", {
    pattern = {"gitcommit"},
    callback = function()
        vim.api.nvim_set_option_value("textwidth", 72, {scope = "local"})
    end
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = {"markdown"},
    callback = function()
        vim.api.nvim_set_option_value("textwidth", 0, {scope = "local"})
        vim.api.nvim_set_option_value("wrapmargin", 0, {scope = "local"})
        vim.api.nvim_set_option_value("linebreak", true, {scope = "local"})
    end
})


-- Fixes Autocomment
vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function()
    vim.cmd "set formatoptions-=cro"
  end,
})

function _G.set_terminal_keymaps()
  local opts = {buffer = 0}
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.api.nvim_create_autocmd({ "TermOpen" }, {
  pattern = [[term://*]],
  callback = function()
    vim.cmd "set nonu"
    set_terminal_keymaps()
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

