" base key mapping

let mapleader=','

nnoremap ;  :
inoremap jk  <ESC>
inoremap jj  <ESC>

nnoremap <leader>w  <c-w>
nnoremap <leader>tf @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>0
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

nnoremap <S-q> :bdelete!<CR>
nnoremap <S-l> :bnext<CR>
nnoremap <S-h> :bprevious<CR>

tnoremap <Esc><Esc> <C-\><C-N>
