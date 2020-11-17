# a vim config and script for HuanGong vim workspace

在Language server变得像现在这样成熟之前, 一直配置使用YoucompleteMe作为主力插件使用, 不过随着
LanguageServer的崛起, NeoVim、vim8的发展, 开始了一些变化, YouCompleteMe的作者也在积极的做lsp
的整合,鉴于自己的使用习惯与对环境setup的要求, 目前配置了三套兼容且方便的配置

- base
仅仅包行基本的插件与配置文件, 且基础的使用依赖均在仓库中带了对应可以使用的版本, 对无网络环境
也可以做一个基本的配置使用

- ycm
在base的基础上, 仅仅多了YoucomplteMe的一点点配置, 非常干净.
```vimscript
source $HOME/.vim/vimrc.base

"""""""""""""""""""""""""""""Plug settings""""""""""""""""""""""""""
call plug#begin('~/.vim/Plug/')
source $HOME/.vim/plugin.base
Plug 'liuchengxu/vista.vim'
Plug 'ycm-core/YouCompleteMe', {'do': './install.py --clangd-completer'}
call plug#end()

if executable("rg")
  let g:ycm_clangd_binary_path = 'clangd'
endif

nmap <leader>gd :YcmCompleter GoToDefinitionElseDeclaration <C-R>=expand("<cword>")<CR><CR>
```

- coc
在base的基础上, 使用coc.nvim这个黑马插件, 需要依赖其本身的nodejs环境, 而且其开发方向求大求全,看着
目标是奔向vim版本的vscode去的. 而对于我个人理解, vim的魅力就在于vim哲学. 而不是vscode哲学.加上在
vim8的补全过程中,latency不稳定.于是在YCM完成LSP的支持发布后, 我转回了YCM.不过我任然在配置上支持
可以在需要的时候进行转换.
```vimscript
source $HOME/.vim/vimrc.base

"""""""""""""""""""""""""""""Plug settings""""""""""""""""""""""""""
call plug#begin('~/.vim/Plug/')
source $HOME/.vim/plugin.base
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()
""""""""""""""""""""""""""""""""" Plug END""""""""""""""""""""""""""


" >>>>>>>>>>>>>>>>>>> config coc start >>>>>>>>>>>>>>>>>>>>>>>>>
nmap <leader>gd <Plug>(coc-definition)
nmap <leader>gt <Plug>(coc-type-definition)
nnoremap <silent> <leader>lo  :<C-u>CocList outline<cr>
nnoremap <silent> <leader>lc  :<C-u>CocList commands<cr>
nnoremap <silent> <leader>ld  :<C-u>CocList diagnostics<cr>

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif
"<<<<<<<<<<<<<<<<<<<< end coc concif <<<<<<<<<<<<<<<<<<<<<

扩展列表
coc-tag
coc-snippets
coc-lists
coc-highlight
coc-sh
coc-python
coc-json
coc-clangd

```

