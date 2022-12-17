" base key mapping

let mapleader=','

nnoremap ;  :
inoremap jk  <ESC>
inoremap jj  <ESC>

nnoremap <leader>w  <c-w>
" za: foldtoggle   zo: fold open  zc: fold close 

inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>0
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

nnoremap <silent><S-q> :bdelete!<CR>
nnoremap <silent><S-l> :bnext<CR>
nnoremap <silent><S-h> :bprevious<CR>

tnoremap <silent><Esc><Esc> <C-\><C-N>
