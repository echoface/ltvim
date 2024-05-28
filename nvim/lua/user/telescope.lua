local status_ok, telescope = pcall(require, "telescope")
if not status_ok then return end

local actions = require "telescope.actions"

telescope.setup {
    defaults = {
        theme = "center",
        layout_strategy = "horizontal", -- bottom_pane|horizontal|vertical|cursor|cneter
        -- sorting_strategy = "ascending",
        layout_config = {
            width = 0.95,
            height = 0.95,
            horizontal = {
                preview_width = 0.65,
                prompt_position = "top",
            },
        },
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
        lsp_document_symbols = { symbol_width = 48, show_line = false, },
        lsp_workspace_symbols = { symbol_width = 48, show_line = false, },
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
        },
        file_browser = {
            hijack_netrw = true,
            -- mappings = {
            --     ["i"] = {
            --         -- your custom insert mode mappings
            --     },
            --     ["n"] = {
            --         -- your custom normal mode mappings
            --     },
            -- },
        },
    },
}

telescope.load_extension("ui-select")
telescope.load_extension("file_browser")

-- Telescope
local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
keymap("n", "<c-p>", ":Telescope <CR>", opts)
keymap("n", "<leader>fc", ":Telescope commands<CR>", opts)
keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)
keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
keymap("n", "<leader>fr", ":Telescope oldfiles<CR>", opts)
keymap("n", "<leader>fg", ":Telescope live_grep<CR>", opts)
keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
keymap("n", "<leader>fe", ":Telescope diagnostics<CR>", opts)
keymap("n", "<leader>fu", ":Telescope lsp_references<CR>", opts)
keymap("n", "<leader>fd", ":Telescope lsp_definitions<CR>", opts)
keymap("n", "<leader>fi", ":Telescope lsp_implementations<CR>", opts)
keymap("n", "<leader>fds", ":Telescope lsp_document_symbols<CR>", opts)
keymap("n", "<leader>fws", ":Telescope lsp_workspace_symbols<CR>", opts)
