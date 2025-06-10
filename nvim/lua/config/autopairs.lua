require("nvim-autopairs").setup {
    check_ts = true, -- treesitter integration
    enable_check_bracket_line = false,
    disable_filetype = { "TelescopePrompt", "guihua", "guihua_rust", "clap_input" },
}
