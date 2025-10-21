local function setup()
    vim.opt.termguicolors = true -- set term gui colors (most terminals support this)

    local bufferline = require("bufferline")

    -- Close buffers
    local opts = { silent = true }
    vim.keymap.set("n", "<S-q>", "<cmd>Bdelete!<CR>", opts)
    bufferline.setup {
        options = {
            -- style_preset = bufferline.style_preset.minimal, -- or bufferline.style_preset.minimal,
            close_command = "Bdelete! %d",                  -- can be a string | function, see "Mouse actions"
            right_mouse_command = "Bdelete! %d",            -- can be a string | function, see "Mouse actions"
            show_close_icon = false,
            show_buffer_icons = false,                      -- disable filetype icons for buffers
            show_buffer_close_icons = false,
            offsets = {
                { filetype = "alpha",    text = "", padding = 1 },
                { filetype = "neo-tree", text = "", padding = 1 },
                { filetype = "NvimTree", text = "", padding = 1 },
            },
            separator_style = "thin", -- | "thick" | "thin" | { 'any', 'any' },
            -- diagnostics = 'nvim_lsp', -- encounter 100% cpu usage issue
        },
    }
end

return {
    "akinsho/bufferline.nvim",
    version = '*',
    event = { "BufEnter" },
    config = setup,
}
