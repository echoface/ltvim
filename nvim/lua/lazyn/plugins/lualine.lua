return {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
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
            return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
        end

        require("lualine").setup {
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
                lualine_c = { diagnostics },
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
    end
}
