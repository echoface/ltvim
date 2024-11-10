-- ref from:https://github.com/mawkler/nvim/blob/master/lua/utils/formatting.lua#L21

local b = vim.b

local augroup = vim.api.nvim_create_augroup('Autoformat', {})


local function format_use_null_ls_first(buf)
    local null_ls_sources = require('null-ls.sources')
    local ft = vim.bo[buf].filetype

    local has_null_ls = #null_ls_sources.get_available(ft, 'NULL_LS_FORMATTING') > 0

    vim.lsp.buf.format({
        bufnr = buf,
        filter = function(client)
            return has_null_ls and client.name == 'null-ls' or true
        end,
    })
end

local M = {}
M.enbale_format_on_write = function(client, bufnr)
    if client.supports_method('textDocument/formatting') then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
                if b.format_on_write ~= false then
                    format_use_null_ls_first(bufnr)
                end
            end,
        })
    end
end

return M
