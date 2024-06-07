
"let test#go#gotest#options = {
"  \ 'all': '-gcflags=-l',
"  \ 'nearest': '-gcflags=-l',
"  \ }

let g:test#strategy = "basic"
let g:test#preserve_screen = 1
let g:test#go#gotest#options = '-gcflags="all=-N -l"'

let g:test#basic#start_normal = 1 " If using basic strategy

let g:test#neovim#start_normal = 1 " If using neovim strategy
let g:test#neovim#kill_previous = 1  " Try to abort previous run

let g:test#neovim_sticky#start_normal = 1 " If using neovim strategy
let g:test#neovim_sticky#kill_previous = 1  " Try to abort previous run

