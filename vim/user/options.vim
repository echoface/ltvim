" <<<<<<<<<<<<<<<<<<<<< base <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
set hidden
set showmatch
set incsearch
set ignorecase

set nobackup
set noswapfile
set nowritebackup
set nocompatible
set updatetime=1000
set backspace=indent,eol,start
set clipboard^=unnamed,unnamedplus

set cmdheight=1
set scrolloff=8                   " 光标移动到buffer的顶部和底部时保持3行距离
set laststatus=2                  " 启动显示状态行(1),总是显示状态行(2)
set smartindent                   " make indenting smarter again

set number
set shortmess+=cF
set signcolumn=number             " no diagnostic
set whichwrap+=<,>,[,]
set completeopt="menuone,preview,noselect"

set nowrap
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

colorscheme molokai

