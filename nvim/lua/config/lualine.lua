local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
    return
end

local hide_in_width = function()
    return vim.fn.winwidth(0) > 80
end

local diagnostics = {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    sections = { "error", "warn" },
    symbols = { error = " ", warn = " " },
    colored = false,
    always_visible = true,
}

local diff = {
    "diff",
    colored = false,
    symbols = { added = "", modified = "", removed = "" }, -- changes diff symbols
    cond = hide_in_width,
}

local filetype = {
    "filetype",
    icons_enabled = false,
}

local spaces = function()
    return "spaces: " .. vim.api.nvim_get_option_value("shiftwidth", {})
end

local lspprogress = {
    function()
        return require('lsp-progress').progress()
    end,
    cond = hide_in_width,
}

lualine.setup {
    options = {
        globalstatus = true,
        icons_enabled = true,
        theme = "auto",
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = { "alpha", "dashboard" },
        always_divide_middle = true,
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch" },
        lualine_c = {
            { 'filename', path = 1 },
            diagnostics,
            lspprogress,
        },
        lualine_x = { diff, spaces, "encoding", filetype },
        lualine_y = {},
        lualine_z = {},
    },
    refresh = {
        winbar = 3000,
        tabline = 3000,
        statusline = 3000,
    },
}

-- listen lsp-progress event and refresh lualine
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
    group = "lualine_augroup",
    pattern = "LspProgressStatusUpdated",
    callback = require("lualine").refresh,
})
