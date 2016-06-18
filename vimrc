set nocp
set magic							            " 设置 regulation express
set cindent
set cinoptions=l1
set cinoptions+=:0
set tabstop=2
set expandtab
set showmatch
set autoindent                    "自动对齐
set smartindent                   "智能对齐
set matchtime=2
set shiftwidth=2
set softtabstop=2

set incsearch
set noswapfile
set ignorecase

set scrolloff=3							      " 光标移动到buffer的顶部和底部时保持3行距离
set laststatus=2						      " 启动显示状态行(1),总是显示状态行(2)
set history=1000 						      " 历史记录数量
set selection=inclusive           "
set backspace=indent,eol,start


syntax on
filetype on
syntax enable
filetype plugin on
filetype indent on

set pumheight=20
set completeopt=menu,menuone
":highlight Pmenu ctermfg=darkblue ctermbg=white
":highlight PmenuSel ctermfg=white ctermbg=lightblue

set foldenable				  			" 开始折叠
set foldmethod=syntax					" 设置语法折叠
set foldlevelstart=99					" 打开文件是默认不折叠代码

if &term == "xterm"
  set t_Co=256
endif

color monokai

autocmd FileType c,cpp set shiftwidth=2 | set expandtab

let mapleader=','
nnoremap ;  :
inoremap jj <ESC>
inoremap JJ <ESC>
nnoremap <leader>dbg <ESC>o<ESC>:call PrintDebug()<CR>==

nnoremap <leader>w <c-w>w
nnoremap <Leader>ch :A<CR>
nnoremap <leader>ff @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

let g:tagbar_autoclose = 1
let g:NERDTreeDirArrows = 1
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
noremap <F3>  :NERDTreeToggle<CR>
noremap <Leader>t <ESC>:TagbarToggle<cr>


"""""""""""""""""""""""""""""Bundle settings""""""""""""""""""""""""""
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

"Bundle 'EasyMotion'
Bundle 'synmark.vim'
Bundle 'gmarik/vundle'
Bundle 'majutsushi/tagbar'
Bundle 'The-NERD-Commenter'
Bundle 'Valloric/ListToggle'
Bundle 'scrooloose/nerdtree'
Bundle 'Valloric/YouCompleteMe'
Bundle 'octol/vim-cpp-enhanced-highlight'

filetype plugin indent on
""""""""""""""""""""""""""""""""" Bundle END""""""""""""""""""""""""""

let g:cpp_class_scope_highlight = 1

"""""""""""""""""""""" configure for youcompleteme """"""""""""""""""""""""""""""
let g:ycm_confirm_extra_conf=0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_complete_in_strings = 1
let g:ycm_use_ultisnips_completer = 1
"let g:ycm_seed_identifiers_with_syntax = 0
"let g:ycm_min_num_of_chars_for_completion = 4
let g:ycm_collect_identifiers_from_tags_files=0
"let g:ycm_min_num_identifier_candidate_chars = 3
let g:ycm_autoclose_preview_window_after_completion=1
let g:ycm_global_ycm_extra_conf = '~/.vim/ycm_project_config.py'
nnoremap <leader>g :YcmCompleter GoToDefinitionElseDeclaration<CR>

function PrintDebug()
  call setline(line("."), 'printf("\n\x1b[31m==%s %s <<%s>> [%d]====\x1b[0m", __FILE__, __FUNCTION__, "", 0);')
endfunction

highlight WhitespaceEOL ctermbg=red guibg=red
match WhitespaceEOL /\s\+$/

function RemoveTrailingWhitespace()
 if &ft != "diff"
  let b:curcol = col(".")
  let b:curline = line(".")
  silent! %s/\s\+$//
  call cursor(b:curline, b:curcol)
 endif
endfunction

autocmd BufWritePre * call RemoveTrailingWhitespace()

autocmd BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif


