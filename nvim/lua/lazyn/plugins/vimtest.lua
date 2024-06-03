local function vimtest_setup()
    vim.cmd [[
        let g:test#strategy = "neovim"
        let g:test#preserve_screen = 1
        let g:test#go#gotest#options = '-gcflags="all=-N -l"'
        let g:test#neovim#start_normal = 1 " If using neovim strategy
        let g:test#basic#start_normal = 1 " If using basic strategy
    ]]
end

return {
    "vim-test/vim-test",
    cmd = {"TestNearest", "TestFile"},
    config = vimtest_setup,
}
