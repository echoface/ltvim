-- Setup nvim-cmp.
local status_ok, npairs = pcall(require, "nvim-autopairs")
if not status_ok then
    return
end

npairs.setup {
    check_ts = true, -- treesitter integration
    enable_check_bracket_line = false,
    disable_filetype = { "TelescopePrompt", "guihua", "guihua_rust", "clap_input" },
}

