-- ref from:https://github.com/mawkler/nvim/blob/master/lua/utils/formatting.lua#L21

local M = {}

local augroup = vim.api.nvim_create_augroup('Autoformat', {})

M.format_use_null_ls_first = function(buf, async)
    local null_ls_sources = require('null-ls.sources')
    local ft = vim.bo[buf].filetype

    local has_null_ls = #null_ls_sources.get_available(ft, 'NULL_LS_FORMATTING') > 0

    vim.lsp.buf.format({
        bufnr = buf,
        async = async,
        timeout_ms = 1000,
        filter = function(client)
            if not has_null_ls then
                return true
            end
            return client.name == 'null-ls'
        end,
    })
end

M.enable_format_on_write = function(client, bufnr)
    if client:supports_method('textDocument/formatting') then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
                if not vim.bo[bufnr].modified then
                    return
                end
                M.format_use_null_ls_first(bufnr, false)
            end,
        })
    end
end

local idle_fmt_augroup = vim.api.nvim_create_augroup("LSPIdleFormat", { clear = true })

local enable_autofmt_when_idle = function(fts)
    vim.api.nvim_clear_autocmds({ group = idle_fmt_augroup, })
    vim.api.nvim_create_autocmd("CursorHold", {
        pattern = fts,
        group = idle_fmt_augroup,
        callback = function(ev)
            if vim.bo[ev.buf].readonly then
                return
            end
            if not vim.bo[ev.buf].modified then
                return
            end
            M.format_use_null_ls_first(ev.buf, false)
        end,
    })
end

local create_cmd_toggle_autofmt_when_idle = function()
    vim.api.nvim_create_user_command("ToggleIdleFmt", function()
        local autocmds = vim.api.nvim_get_autocmds({
            group = idle_fmt_augroup,
        })
        if #autocmds > 0 then
            vim.api.nvim_clear_autocmds({ group = idle_fmt_augroup, })
        else
            enable_autofmt_when_idle()
        end
    end, {})
end

local default_opts = {
    idlfmt_ftypes = { "*.go", "*.py", "*.c", "*.cpp", "*.lua", "*.yaml" },
}

M.setup = function(opts)
    default_opts = vim.tbl_extend('force', default_opts, opts)

    create_cmd_toggle_autofmt_when_idle()

    if default_opts.idlfmt_ftypes ~= nil then
        enable_autofmt_when_idle(default_opts.idlfmt_ftypes)
    end
end

return M
