local status_ok, nvimtree = pcall(require, "nvim-tree")
if not status_ok then return end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

vim.keymap.set("n", "tt", ":NvimTreeFindFileToggle<CR>", { noremap = true, silent = true })

local function on_attach(bufnr)
    local api = require('nvim-tree.api')

    local function opts(desc)
        return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
    end

    api.config.mappings.default_on_attach(bufnr)

    -- You will need to insert "your code goes here" for any mappings with a custom action_cb
    vim.keymap.set('n', 'o', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', 'e', api.node.open.edit, opts('Open'))
    vim.keymap.set('n', 'C', api.tree.change_root_to_node, opts('CD'))
    vim.keymap.set('n', 'u', api.tree.change_root_to_parent, opts('Up'))
    vim.keymap.set('n', '-', api.tree.change_root_to_parent, opts('Up'))
    vim.keymap.set('n', 's', api.node.open.vertical, opts('Open: Vertical Split'))
end

local HEIGHT_RATIO = 0.8 -- You can change this
local WIDTH_RATIO = 0.64 -- You can change this too

local function center_float()
    local screen_w = vim.opt.columns:get()
    local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
    local window_w = screen_w * WIDTH_RATIO
    local window_h = screen_h * HEIGHT_RATIO
    local window_w_int = math.floor(window_w)
    local window_h_int = math.floor(window_h)
    local center_x = (screen_w - window_w) / 2
    local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()

    return {
        -- relativenumber = true,
        adaptive_size = true,
        -- ref: https://github.com/MarioCarrion/videos/tree/main/2023
        float = {
            enable = true,
            open_win_config = {
                border = "rounded",
                relative = "editor",
                row = center_y,
                col = center_x,
                width = window_w_int,
                height = window_h_int,
            }
        },
        width = window_w_int,
    }
end

local function right_view(float)
    local screen_w = vim.opt.columns:get()
    local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()

    local window_w = 42
    local window_h = screen_h * 0.95
    local window_w_int = math.floor(window_w)
    local window_h_int = math.floor(window_h)

    local center_x = (screen_w - window_w) - 2
    local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()

    return {
        -- relativenumber = true,
        adaptive_size = true,
        -- ref: https://github.com/MarioCarrion/videos/tree/main/2023
        side = "right",
        float = {
            enable = float,
            quit_on_focus_loss = true,
            open_win_config = {
                border = "rounded",
                relative = "editor",
                row = center_y,
                col = center_x,
                width = window_w_int,
                height = window_h_int,
            }
        },
        width = window_w_int,
    }
end

nvimtree.setup({
    hijack_netrw = true,
    disable_netrw = true,
    respect_buf_cwd = true,
    sync_root_with_cwd = true,
    reload_on_bufenter = false,
    update_focused_file = {
        enable = true,
        update_root = true
    },
    on_attach = on_attach,
    view = center_float(),
    -- view = right_view(true),
    git = {
        enable = false,
    },
    filters = {
        enable = true,
        git_ignored = true,
        dotfiles = false,
        git_clean = true,
        no_buffer = false,
        no_bookmark = false,
        custom = {
            "^.git$", "*.log",
            "^__?+__", "%.pyc$", "%.pyo$", "^__pycache__$", "^__init__.py$",
        },
        exclude = {},
    },
    actions = {
        open_file = {
            quit_on_open = true,
        },
    },
})
