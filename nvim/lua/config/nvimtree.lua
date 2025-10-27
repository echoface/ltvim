local status_ok, nvimtree = pcall(require, "nvim-tree")
if not status_ok then return end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.keymap.set("n", "tf", ":NvimTreeFindFileToggle<CR>", { noremap = true, silent = true })

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

local function tree_view(pos, enable_float)
    local HEIGHT_RATIO = 0.8 -- You can change this
    local WIDTH_RATIO = 0.64 -- You can change this too

    return {
        side = (pos == "right") and "right" or "left",
        signcolumn = "no",
        -- relativenumber = true,
        adaptive_size = true,
        float = {
            enable = enable_float,
            quit_on_focus_loss = true,
            open_win_config = function()
                local screen_w = vim.opt.columns:get()
                local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()

                local row = 1
                local col = 0
                local window_w_int = 42
                local window_h_int = math.floor(screen_h - 4)

                if pos == "center" then
                    window_w_int = math.floor(screen_w * WIDTH_RATIO)
                    window_h_int = math.floor(screen_h * HEIGHT_RATIO)

                    col = (screen_w - window_w_int) / 2
                    row = ((vim.opt.lines:get() - window_h_int) / 2 - vim.opt.cmdheight:get())
                elseif pos == "right" then
                    col = screen_w - window_w_int
                end

                return {
                    border = 'rounded',
                    relative = 'editor',
                    row = row,
                    col = col,
                    width = window_w_int,
                    height = window_h_int,
                }
            end
        },
        width = function()
            if pos ~= "center" then
                return 42
            end
            return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
        end,
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
    view = tree_view("right", false),
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
            quit_on_open = false,
        },
    },
})
