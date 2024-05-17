
vim.cmd [[

let g:test#strategy = "neovim"
let g:test#go#gotest#options = '-gcflags="all=-N -l"'
let g:test#preserve_screen = 1
let g:test#neovim#start_normal = 1 " If using neovim strategy
let g:test#basic#start_normal = 1 " If using basic strategy

]]

require('go').setup({
    -- notify: use nvim-notify
    notify = true,
    -- auto commands
    auto_format = true,
    auto_lint = false,
    -- linters: revive, errcheck, staticcheck, golangci-lint
    linter = 'revive',
    -- linter_flags: e.g., {revive = {'-config', '/path/to/config.yml'}}
    linter_flags = {},
    -- lint_prompt_style: qf (quickfix), vt (virtual text)
    lint_prompt_style = 'qf',
    -- formatter: goimports, gofmt, gofumpt, lsp
    formatter = 'goimports',
    -- maintain cursor position after formatting loaded buffer
    maintain_cursor_pos = false,
    -- test flags: -count=1 will disable cache
    test_flags = {'-gcflags="all=-N -l"'},
    test_timeout = '30s',
    test_env = {},
    -- show test result with popup window
    test_popup = true,
    test_popup_auto_leave = false,
    test_popup_width = 80,
    test_popup_height = 10,
    -- test open
    test_open_cmd = 'edit',
    -- struct tags
    tags_name = 'json',
    tags_options = {'json=omitempty'},
    tags_transform = 'snakecase',
    tags_flags = {'-skip-unexported'},
    -- quick type
    quick_type_flags = {'--just-types'},
})

