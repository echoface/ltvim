local function setup_alpha()
    -- Remove statusline and tabline when in Alpha
    vim.api.nvim_create_autocmd({ "User" }, {
        pattern = { "AlphaReady" },
        callback = function()
            vim.cmd [[
                set laststatus=0 | autocmd BufUnload <buffer> set laststatus=3
                set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
            ]]
        end,
    })

    local dashboard = require "alpha.themes.dashboard"
    dashboard.section.header.val = {
        [[SuperHgO NeoVim]],
    }
    dashboard.section.buttons.val = {
        dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
        dashboard.button("e", " " .. " New file", ":ene <BAR> startinsert <CR>"),
        dashboard.button("p", " " .. " Find project", ":lua require('telescope').extensions.projects.projects()<CR>"),
        dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
        dashboard.button("g", " " .. " Find text", ":Telescope live_grep <CR>"),
        dashboard.button("c", " " .. " Config", ":e ~/.config/nvim/init.lua <CR>"),
        dashboard.button("q", " " .. " Quit", ":qa<CR>"),
    }

    dashboard.section.footer.val = "ECHOFACE"
    dashboard.section.footer.opts.hl = "Type"
    dashboard.section.header.opts.hl = "Include"
    dashboard.section.buttons.opts.hl = "Keyword"

    dashboard.opts.opts.noautocmd = true

    require("alpha").setup(dashboard.opts)
end

return {
    "goolord/alpha-nvim",
    config = setup_alpha
}
