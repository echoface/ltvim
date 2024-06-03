return {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
        require("nvim-autopairs").setup {
            check_ts = true, -- treesitter integration
            enable_check_bracket_line = false,
            disable_filetype = { "TelescopePrompt", "guihua", "guihua_rust", "clap_input" },
        }

        local nvimcmp = require("cmp")
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        nvimcmp.event:on("confirm_done", cmp_autopairs.on_confirm_done {})
    end
}
