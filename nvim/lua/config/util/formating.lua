-- ref from:https://github.com/mawkler/nvim/blob/master/lua/utils/formatting.lua#L21

local M = {}

local augroup = vim.api.nvim_create_augroup('Autoformat', {})

--- 格式化函数：优先指定 client，否则使用第一个支持 formatter 的 client
-- @param bufnr (integer) buffer id, 默认 0
-- @param async (boolean) 是否异步
-- @param timeout (number) 超时事件
-- @param prefer_client (string|nil) 优先使用的 client 名称，如 "null-ls"
M.format_with_priority = function(bufnr, async, timeout, prefer_client)
    bufnr = bufnr or 0
    timeout = timeout or 1000
    local clients = vim.lsp.get_clients({ bufnr = bufnr })
    local target = nil

    -- 1. 如果指定 prefer_client，则优先找它
    if prefer_client then
        for _, client in ipairs(clients) do
            if client.name == prefer_client and client:supports_method("textDocument/formatting", bufnr) then
                target = client
                break
            end
        end
    end

    -- 2. fallback：选第一个支持 textDocument/formatting 的 client
    if not target then
        for _, client in ipairs(clients) do
            if client:supports_method("textDocument/formatting", bufnr) then
                target = client
                break
            end
        end
    end

    -- 3. 如果没找到，提示错误
    if not target then
        vim.notify("No LSP client supports formatting", vim.log.levels.WARN)
        return
    end

    vim.notify("format use " .. target.name, vim.log.levels.INFO)
    -- 4. 调用格式化，仅用选中的 client
    vim.lsp.buf.format({
        bufnr = bufnr,
        async = async,
        filter = function(client) return client.id == target.id end,
        timeout_ms = timeout,
    })
end

M.enable_format_on_write = function(client, bufnr)
    if client:supports_method('textDocument/formatting') then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function(ev)
                if vim.bo[ev.buf].readonly then
                    return
                end
                if not vim.bo[bufnr].modified then
                    return
                end
                M.format_with_priority(bufnr, false, 3000, "null-ls")
            end,
        })
    end
end

M.setup = function(opts)
end

return M
