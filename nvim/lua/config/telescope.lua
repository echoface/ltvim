local telescope = require("telescope")
local actions = require("telescope.actions")
telescope.setup({
    defaults = {
        -- theme = "center",
        -- layout_strategy = "horizontal", -- bottom_pane|horizontal|vertical|cursor|cneter
        -- sorting_strategy = "ascending",
        -- layout_config = {
        --     width = 0.95,
        --     height = 0.95,
        --     horizontal = {
        --         preview_width = 0.65,
        --         prompt_position = "top",
        --     },
        -- },
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
            use_fd = true,          -- use `fd` instead of plenary, make sure to install `fd`
            path = "%:p:h",         -- open from within the folder of your current buffer
            grouped = true,         -- group initial sorting by directories and then files
            hidden = true,          -- show hidden files
            hijack_netrw = true,    -- use telescope file browser when opening directory paths
            prompt_path = true,     -- show the current relative path from cwd as the prompt prefix
            display_stat = false,   -- don't show file stat
            hide_parent_dir = true, -- hide `../` in the file browser
        }
    }
})

telescope.load_extension("fzf")
telescope.load_extension("ui-select")
telescope.load_extension("file_browser")

local ok, _ = pcall(require, "project_nvim")
if ok then
    telescope.load_extension('projects')
    vim.api.nvim_create_user_command("Projects", function ()
        vim.cmd("Telescope projects")
    end, {})
end


-- key maps
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
keymap("n", "<leader>fs", ":Telescope lsp_document_symbols<CR>", opts)

