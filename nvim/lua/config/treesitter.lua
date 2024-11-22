local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    return
end

local function has_value(tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end
    return false
end

-- big json file buggy when use treesitter.foldexpr
vim.api.nvim_create_autocmd({ "FileType" }, {
    -- pattern = {"c", "c++", "go", "python", "lua", "json"},
    callback = function()
        vim.defer_fn(function()
            local file_path = vim.api.nvim_buf_get_name(0) -- Get the path of the current buffer
            local file_size = vim.fn.getfsize(file_path)   -- Get the size of the file in bytes
            local parser_ok, parser = pcall(require, "nvim-treesitter.parsers")
            if parser_ok and parser.has_parser() and file_size < 1024 * 1024 then
                vim.opt.foldmethod = "expr"
                vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
            else
                vim.opt.foldmethod = "indent"
            end
        end, 100)
    end,
})

local disable_hi_list = { "css", "json" }
local function ts_disable(lang, bufnr)
    return has_value(disable_hi_list, lang) or vim.api.nvim_buf_line_count(bufnr) > 5000
end

treesitter.setup({
    ignore_install = { "css" },
    -- ensure_installed = {
    --     "c", "cpp", "lua", "python", "go", "proto",
    -- },
    modules = {},
    auto_install = true,
    sync_install = false,
    highlight = {
        enable = true,
        disable = ts_disable,
    },
    indent = {
        enable = true,
        disable = { "python", "css", "go" } -- go's indent has mistake for 'switch' case
    },
})
