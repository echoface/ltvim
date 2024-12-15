return {
    "kevinhwang91/nvim-bqf",
    lazy    = false,
    ft      = { "qf" },
    enabled = true,
    version = "*",
    opts    = {
        auto_enable = true,
        auto_resize_height = true, -- highly recommended enable
        preview = {
            win_height = 24,
            win_vheight = 12,
            delay_syntax = 80,
            border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
            show_title = false,
            should_preview_cb = function(bufnr, qwinid)
                local ret = true
                local bufname = vim.api.nvim_buf_get_name(bufnr)
                local fsize = vim.fn.getfsize(bufname)
                if fsize > 100 * 1024 then
                    -- skip file size greater than 100k
                    ret = false
                elseif bufname:match("^fugitive://") then
                    -- skip fugitive buffer
                    ret = false
                end
                return ret
            end,
        },
        filter = {
            fzf = {
                action_for = { ["ctrl-s"] = "split", ["ctrl-t"] = "tab drop" },
                extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
            },
        },
    },
}
