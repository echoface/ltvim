local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
  return
end

local actions = require "telescope.actions"

telescope.setup {
    defaults = {
        -- layout_strategy = "center", -- bottom_pane|horizontal|vertical|cursor|cneter
        mappings = {
            i = {
                ["<Up>"] = actions.cycle_history_prev,
                ["<Down>"] = actions.cycle_history_next,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
            },
        },
        file_ignore_patterns = { ".git/", "node_modules" },
    },
    pickers = {
        lsp_document_symbols = { symbol_width=48, },
        lsp_workspace_symbols = { symbol_width=48, },
    },
}

local has_selector, _ = pcall(require, "telescope-ui-select")
if has_selector then
  telescope.load_extension("ui-select")
end

-- Telescope
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
keymap("n", "<c-p>", ":Telescope <CR>", opts)
keymap("n", "<leader>fc", ":Telebcope commands<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)
keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
keymap("n", "<leader>fr", ":Telescope oldfiles<CR>", opts)
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fe", ":Telescope diagnostics<CR>", opts)
keymap("n", "<leader>fu", ":Telescope lsp_references<CR>", opts)
keymap("n", "<leader>fd", ":Telebcope lsp_definitions<CR>", opts)
keymap("n", "<leader>fi", ":Telescope lsp_implementations<CR>", opts)
keymap("n", "<leader>fs", ":Telescope lsp_document_symbols<CR>", opts)
