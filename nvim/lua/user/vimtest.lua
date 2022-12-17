
vim.cmd [[let test#strategy = "neovim"]]

vim.cmd [[
let test#go#gotest#options = {
  \ 'all': '-gcflags=-l',
  \ 'nearest': '-gcflags=-l',
  \ }
]]
