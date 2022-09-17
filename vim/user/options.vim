" <<<<<<<<<<<<<<<<<<<<< base <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
set hidden
set showmatch
set incsearch
set ignorecase

set nobackup
set noswapfile
set nowritebackup
set nocompatible
set backspace=indent,eol,start

set cmdheight=1
set updatetime=300
set scrolloff=8                   " 光标移动到buffer的顶部和底部时保持3行距离
set laststatus=2                  " 启动显示状态行(1),总是显示状态行(2)
set smartindent                   " make indenting smarter again

set number
set shortmess+=c
set signcolumn=number             " no diagnostic
set whichwrap+=<,>,[,]

set encoding=utf-8
set fileformat=unix
set termencoding=utf-8

" indent default setting
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2

set foldenable                " 开始折叠
set foldmethod=syntax         " 设置语法折叠
set foldlevelstart=99         " 打开文件是默认不折叠代码

syntax enable
filetype plugin indent on

colorscheme monokai

" base key mapping
nnoremap ;  :
let mapleader=','
nnoremap <leader>w  <c-w>
nnoremap <leader>tf @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

inoremap <C-e> <C-o>$
inoremap <C-a> <C-o>0
inoremap <expr> <C-j> pumvisible() ? "\<C-n>" : "\<C-j>"
inoremap <expr> <C-k> pumvisible() ? "\<C-p>" : "\<C-k>"

autocmd BufNewFile,BufRead *.lua setlocal et ts=2 sw=2 sts=2
autocmd BufNewFile,BufRead *.go setlocal noet ts=4 sw=4 sts=4
autocmd BufNewFile,BufRead python setlocal et ts=4 sw=4 sts=4
autocmd BufNewFile,BufRead c,cpp,objc setlocal et ts=2 sw=2 sts=2
" <<<<<<<<<<<<<<<<<<<<< base end <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<

" >>>>>>>>>>>>>>>>>>>>> highlight >>>>>>>>>>>>>>>>>>>>>>>>>
highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/

function RemoveTrailingSpace()
  if &ft != "diff"
    let b:curcol = col(".")
    let b:curline = line(".")
    silent! %s/\s\+$//
    call cursor(b:curline, b:curcol)
  endif
endfunction
autocmd BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
" >>>>>>>>>>>>>>>>>>>>> highlight end >>>>>>>>>>>>>>>>>>>>