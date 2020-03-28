if has('nvim')
  let &packpath=&runtimepath
  set runtimepath^=~/.vim runtimepath+=~/.vim/after
endif

set magic                         " 设置 regulation express
set showmatch
set autoindent                    "自动对齐
set matchtime=2
set nowrap
set incsearch
set noswapfile
set ignorecase

set encoding=utf-8
set termencoding=utf-8

" indent default setting
set tabstop=2
set expandtab
set smartindent                   "智能对齐
set shiftwidth=2
set softtabstop=2

set scrolloff=3                   " 光标移动到buffer的顶部和底部时保持3行距离
set laststatus=2                  " 启动显示状态行(1),总是显示状态行(2)
set history=1000                  " 历史记录数量
set selection=inclusive           "
set backspace=indent,eol,start

syntax on
filetype on
syntax enable
filetype plugin indent on

set pumheight=20
set completeopt=menu,menuone

set foldenable                " 开始折叠
set foldmethod=syntax         " 设置语法折叠
set foldlevelstart=99         " 打开文件是默认不折叠代码

let mapleader=','
colorscheme molokai

"""""""""""""""""""""""""""""Plug settings""""""""""""""""""""""""""
call plug#begin('~/.vim/Plug/')

Plug 'majutsushi/tagbar'
Plug 'ap/vim-buftabline'
Plug 'scrooloose/nerdtree'
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
"Plug 'davidhalter/jedi-vim'
"Plug 'Valloric/YouCompleteMe'

Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'prabirshrestha/async.vim'
"Plug 'prabirshrestha/vim-lsp'
"Plug 'prabirshrestha/asyncomplete.vim'
"Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'Shougo/echodoc.vim'
Plug 'scrooloose/nerdcommenter'
Plug 'skywind3000/asyncrun.vim'
Plug 'easymotion/vim-easymotion'
Plug 'hynek/vim-python-pep8-indent'
Plug 'octol/vim-cpp-enhanced-highlight'
"Plug 'autozimu/LanguageClient-neovim', {'branch': 'next', 'do': 'bash install.sh',}

"if has('nvim')
"  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
"else
"  Plug 'maralla/completor.vim'
"endif
call plug#end()
""""""""""""""""""""""""""""""""" Plug END""""""""""""""""""""""""""

let g:cpp_class_scope_highlight = 1

" >>>>>>>>>>>>>>>>>>>>>>> config nerdtree >>>>>>>>>>>>>>>>>>>>>>>>>>>>>
let g:NERDTreeDirArrows = 1
let g:NERDTreeNodeDelimiter=''
let g:NERDTreeGlyphReadOnly = "RO"
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let NERDTreeIgnore=['\.pyc','\~$','\.swp','\.o']

"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") && v:this_session == "" | NERDTree | endif
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
noremap <leader>ts  :NERDTreeToggle<CR>
" <<<<<<<<<<<<<<<<<<<<<<< config nerdtree >>>>>>>>>>>>>>>>>>>>>>>>>>>>>


" >>>>>>>>>>>>>>>>>>>>> config for LanguageClient + completor >>>>>>>
let g:LanguageClient_serverCommands = {
      \ 'cpp': ['clangd', '-background-index', '-clang-tidy'],
      \}
let g:LanguageClient_selectionUI = 'quickfix'
let g:LanguageClient_changeThrottle = 2
let g:LanguageClient_diagnosticsSignsMax = 3

command! LCMenu call LanguageClient_contextMenu()
command! LCHover call LanguageClient#textDocument_hover()
command! LCRename call LanguageClient#textDocument_rename()
command! LCFormat call LanguageClient#textDocument_formatting()
command! LCFormatSelection call LanguageClient#textDocument_rangeFormatting()

" autocmd FileType python,cpp,d setlocal omnifunc=LanguageClient#complete
" let g:LanguageClient_diagnosticsEnable = 1 " シンタックスチェック
" let g:LanguageClient_loggingFile = expand($VIM.'/_lsplog')
" let g:LanguageClient_serverStderr = expand($VIM.'/_lsperr')
function EnableLSPShortcuts()
  nnoremap <leader>rn :call LanguageClient#textDocument_rename()<CR>
  nnoremap <leader>gd :call LanguageClient#textDocument_definition()<CR>
  nnoremap <leader>gr :call LanguageClient#textDocument_references()<CR>
  nnoremap <leader>gt :call LanguageClient#textDocument_typeDefinition()<CR>

  nnoremap <leader>la :call LanguageClient_workspace_applyEdit()<CR>
  nnoremap <leader>lc :call LanguageClient#textDocument_completion()<CR>
  nnoremap <leader>ls :call LanguageClient_textDocument_documentSymbol()<CR>
endfunction()
augroup LSP
  autocmd!
  autocmd FileType cpp,c call EnableLSPShortcuts()
augroup END
"<<<<<<<<<<<<<<<<<<<< end config LanguageClient + completor <<<<<<<<<<


">>>>>>>>>>>>>>>>>>> start completor config completor 和 deoplete二选一
inoremap <c-c> <ESC>
inoremap <expr> <CR> (pumvisible() ? "\<c-y>\<cr>" : "\<CR>")
inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

if has('nvim') " use deoplete
  let g:echodoc#enable_at_startup = 1
  let g:deoplete#enable_at_startup = 1

  "set cmdheight=1
  set signcolumn=yes
  let g:echodoc#type = 'signature'
else
  let g:completor_min_chars = 3
  let g:completor_auto_trigger = 1
  let g:completor_completion_delay = 100
  " let g:completor_refresh_always = 0 "avoid flickering
  " let g:completor_fuzzy_match = 0
  let g:completor_disable_necosyntax = ['vim','python','cpp','c']
  let g:completor_complete_options = 'menuone,noselect,preview'
  let g:completor_cpp_omni_trigger = '\w+(\.|->|::)\w*$|\w{3,}$'
  let g:completor_python_omni_trigger = '\A\w*$|[^. \t]\.\w*$'
endif
" <<<<<<<<<<<<<<<<<< end completor config <<<<<<<<<<<<<<<<<<<<<


" >>>>>>>>>>>>>>>>>>> config leaderF >>>>>>>>>>>>>>>>>>>>>>>>>
let g:Lf_ShortcutF = '<C-P>'
if executable("rg")
  " search word under cursor, the pattern is treated as regex, and enter normal mode directly
  noremap <leader>fc :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>
  " search word under cursor, the pattern is treated as regex,
  " append the result to previous search results.
  noremap <leader>fg :<C-U><C-R>=printf("Leaderf! rg --append -e %s ", expand("<cword>"))<CR>
  " search word under cursor literally only in current buffer
  noremap <leader>fb :<C-U><C-R>=printf("Leaderf! rg -F --current-buffer -e %s ", expand("<cword>"))<CR>
  " search visually selected text literally, don't quit LeaderF after accepting an entry
  xnoremap <leader>fv :<C-U><C-R>=printf("Leaderf! rg -F --stayOpen -e %s ", leaderf#Rg#visual())<CR>
  " recall last search. If the result window is closed, reopen it.
  noremap <leader>go :<C-U>Leaderf! rg --stayOpen --recall<CR>
else
  set wildchar=<Tab> wildmenu wildmode=full
  nnoremap <leader>fd :AsyncRun grep -rwn <cword> .
  nnoremap <leader>fc :AsyncRun grep -rwn <cword> .<cr>
endif
" <<<<<<<<<<<<<<<<<<<<< end leaderF <<<<<<<<<<<<<<<<<<<<<<<<<<

autocmd User AsyncRunStart call asyncrun#quickfix_toggle(8, 1)

nnoremap ;  :
nnoremap <leader>w  <c-w>
nnoremap <leader>ch :A<CR>
nnoremap <Leader>tt :TagbarToggle<CR>
nnoremap <leader>tq :call asyncrun#quickfix_toggle(8)<cr>
nnoremap <leader>tf @=((foldclosed(line('.')) < 0) ? 'zc' : 'zo')<CR>

" go matche symbol; move start; move end
nnoremap <leader>gm %
nnoremap <leader>me $
nnoremap <leader>ms 0

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

au BufNewFile,BufRead python
    \ set tabstop=4 |
    \ set expandtab |
    \ set autoindent |
    \ set shiftwidth=4 |
    \ set textwidth=79 |
    \ set softtabstop=4 |
    \ set fileformat=unix

" c++0x lambda expr indent
au Filetype cpp,c,objc
    \ setlocal cindent |
    \ setlocal cinoptions=l1 |
    \ setlocal cinoptions+=:0 |
    \ setlocal cino=l1,j1,(0,ws,Ws |
    \ setlocal expandtab tabstop=2 shiftwidth=2


" Better display for messages
set cmdheight=2

" You will have bad experience for diagnostic messages when it's default 4000.
set updatetime=300

" don't give |ins-completion-menu| messages.
set shortmess+=c

" always show signcolumns
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" Use command ':verbose imap <tab>' to make sure tab is not mapped by other plugin.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current position.
" Coc only does snippet and additional edit on confirm.
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" Or use `complete_info` if your vim support it, like:
" inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight symbol under cursor on CursorHold
autocmd CursorHold * silent call CocActionAsync('highlight')

" Remap for rename current word
nmap <leader>rn <Plug>(coc-rename)

" Remap for format selected region
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Remap for do codeAction of selected region, ex: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap for do codeAction of current line
nmap <leader>ac  <Plug>(coc-codeaction)
" Fix autofix problem of current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Create mappings for function text object, requires document symbols feature of languageserver.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <C-d> for select selections ranges, needs server support, like: coc-tsserver, coc-python
nmap <silent> <C-d> <Plug>(coc-range-select)
xmap <silent> <C-d> <Plug>(coc-range-select)

" Use `:Format` to format current buffer
command! -nargs=0 Format :call CocAction('format')

" Use `:Fold` to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" use `:OR` for organize import of current buffer
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add status line support, for integration with other plugin, checkout `:h coc-status`
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Using CocList
" Show all diagnostics
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

