local telescope = require("telescope")
local actions = require("telescope.actions")
telescope.setup({
    defaults = {
        theme = "center",
        layout_strategy = "flex", -- bottom_pane|horizontal|vertical|cursor|cneter|flex
        sorting_strategy = "ascending",
        layout_config = {
            width = 0.95,
            height = 0.90,
            horizontal = {
                preview_width = 0.5,
                prompt_position = "top",
            },
        },
        mappings = {
            n = {
                ["q"] = actions.close,
            },
            i = {
                ["<Up>"] = actions.cycle_history_prev,
                ["<Down>"] = actions.cycle_history_next,
                ["<C-j>"] = actions.move_selection_next,
                ["<C-k>"] = actions.move_selection_previous,
            }
        },
        file_ignore_patterns = { ".git/", "node_modules" },
        path_display = {
            truncate = 3,
            shorten = { len = 2 }, -- only display the first character of each directory in
        }
    },
    pickers = {
        lsp_references = { fname_width = 30, show_line = false, trim_text = true },
        lsp_definitions = { fname_width = 30, show_line = false, trim_text = true },
        lsp_incoming_calls = { fname_width = 30, show_line = false, trim_text = true },
        lsp_outgoing_calls = { fname_width = 30, show_line = false, trim_text = true },
        lsp_document_symbols = { fname_width = 30, symbol_width = 48, show_line = true, },
        lsp_workspace_symbols = { fname_width = 30, symbol_width = 48, show_line = true, },
    },
    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
        },
        fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_file_sorter = true,    -- override the file sorter
            override_generic_sorter = true, -- override the generic sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        }
    }
})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")


local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }
local builtin = require('telescope.builtin')

keymap("n", "<c-p>", ":Telescope <CR>", opts)

-- filter or find logic
keymap('n', '<leader>fb', builtin.buffers, opts)
keymap('n', '<leader>ff', builtin.find_files, opts)
keymap("n", "<leader>fc", builtin.commands, opts)
keymap("n", "<leader>fr", builtin.oldfiles, opts)
keymap("n", "<leader>fe", builtin.diagnostics, opts)
keymap('n', '<leader>fg', builtin.live_grep, opts)
keymap('n', '<leader>f/', builtin.current_buffer_fuzzy_find, opts)

local ok, _ = pcall(require, "project_nvim")
if ok then
    telescope.load_extension('projects')
    vim.api.nvim_create_user_command("Projects", function()
        telescope.extensions.projects.projects {}
    end, {})
end
-- extension cmd
keymap("n", "<leader>fp", telescope.extensions.projects.projects, opts)
