--    README       ---
--  插件无关的设置 ---

-- Use 'q' to quit from common plugins
-- quickfix config below standalone
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = {
        "help", "man", "checkhealth", "lspinfo",
        "notify", "lir", "spectre_panel", "markdown",
        "NvimTree", "mason", "lazy", "null-ls-info",
    },
    callback = function(event) -- 仅对“浮动或只读窗口”生效，避免干扰普通 markdown
        local buf = event.buf
        local win = vim.api.nvim_get_current_win()
        local config = vim.api.nvim_win_get_config(win)
        if config.relative ~= "" or vim.bo[buf].buftype == "help" or vim.bo[buf].buftype == "nofile" then
            vim.cmd [[
            setlocal nobuflisted
            nnoremap <silent> <buffer> q :close<CR>
            nnoremap <silent> <buffer> <ESC> :close<CR>
        ]]
        end
    end,
})

vim.api.nvim_create_user_command('ToggleQuickFix', function(args)
    local qf_exists = false
    for _, win in pairs(vim.fn.getwininfo()) do
        if win["quickfix"] == 1 then
            qf_exists = true
        end
    end
    if qf_exists == true then
        vim.cmd "cclose"
        return
    end
    if not vim.tbl_isempty(vim.fn.getqflist()) then
        vim.cmd "copen"
    end
end, { desc = "Toggle quickfix window", nargs = '*' })

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "qf", "quickfix" },
    callback = function()
        local keymap = vim.keymap.set
        local opts = { noremap = true, silent = true }
        keymap("n", "tq", ":ToggleQuickFix<CR>", opts)

        vim.cmd [[
            setlocal nobuflisted
            nnoremap <buffer> k <Up>
            nnoremap <buffer> j <Down>
            nnoremap <buffer> o <CR>:cclose<CR>      " close quickfix menu after selecting choice
            nnoremap <buffer> <CR> <CR>:cclose<CR>   " close quickfix menu after selecting choice
            "nnoremap <buffer> o <CR><C-w>p          " open and keep focus on qf
            "nnoremap <buffer> <CR> <CR><C-W>p       " open and keep focus on qf
            nnoremap <silent> <buffer> q :cclose<CR>
            nnoremap <silent> <buffer> <ESC> :cclose<CR>
        ]]
    end
})

-- Set wrap and spell in markdown and gitcommit
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "gitcommit", "markdown" },
    callback = function()
        vim.opt_local.wrap = true
        vim.opt_local.number = false
        vim.opt_local.linebreak = true
        vim.opt_local.breakindent = true
        vim.opt_local.showbreak = "↪ "
        vim.opt_local.formatoptions:append("tnlj")
        vim.opt_local.relativenumber = false
        vim.api.nvim_set_option_value("wrapmargin", 3, { scope = "local" })

        -- vim.opt_local.spell = true
        vim.opt_local.colorcolumn = "120"
        -- vim.api.nvim_set_option_value("textwidth", 72, { scope = "local" })
    end,
})


-- Terminal
vim.api.nvim_create_autocmd({ "TermOpen" }, {
    -- pattern = { "terminal", "toggleterm", "snacks_terminal" },
    callback = function()
        local opts = { buffer = 0 }
        vim.keymap.set('t', 'jj', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)

        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)

        vim.opt_local.signcolumn     = "no"
        vim.opt_local.number         = false
        vim.opt_local.relativenumber = false

        --- vim.cmd([[ startinsert ]])
        vim.keymap.set('n', 'q', '<cmd>hide<CR>', opts)
    end,
})

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead", "BufEnter" }, {
    pattern = { "*.go" },
    callback = function()
        vim.opt_local.tabstop = 4
        vim.opt_local.shiftwidth = 4
        vim.opt_local.softtabstop = 4
        vim.opt_local.expandtab = false
    end,
})

-- back last edit position
-- vim.cmd [[autocmd BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif]]
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        local total_lines = vim.api.nvim_buf_line_count(0)
        -- 获取上次编辑位置的行和列
        local last_line, last_col = unpack(vim.api.nvim_buf_get_mark(0, '"'))
        if last_line > 0 and last_line <= total_lines then
            vim.api.nvim_win_set_cursor(0, { last_line, last_col })
        end
    end,
})

vim.diagnostic.config({
    virtual_text = false,     -- disable virtual text
    update_in_insert = false, -- update diagnostic edit
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "󰋼",
            [vim.diagnostic.severity.HINT] = "󰌵",
        },
    }, -- show signs
    float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = true, -- 'if_many'
    },
})

-- command setup
-- display diagnostics when cursor hold only in normal mode
-- when updatetime={not short enough} will cause float window hangout
-- autocmd CursorHold * lua vim.diagnostic.open_float(nil, {focusable=false})
vim.cmd [[
    command! Diagnostics lua vim.diagnostic.open_float(nil, {focus=false})<cr>
    command! DiagnosticsPre lua vim.diagnostic.goto_prev({buffer=0})<cr>
    command! DiagnosticsNext lua vim.diagnostic.goto_next({buffer=0})<cr>
]]
