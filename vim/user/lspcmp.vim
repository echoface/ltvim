" 这里将complete 与 lsp配置合并; 核心时配置补全引擎以及其补全时的数据来源
"
" 编辑时所有的complete操作由asynccomplete提供; 而asyncomplete背后的数据源:
" 1. lsp: 由asyncomplete_lsp提供
"         而asyncomplete_lsp 对接vim-lsp这个lsp框架
"         具体的lsp下载、配置等则由vim-lsp-settings插件完成;无需任何关注
" 2. snips: 由vsnip 提供
"         这里由两种形式,
"         一种是数据直接提供给asyncomplete: codesnips => asyncomplete
"         另一种则是将snips作为lsp: codesnips => vim-lsp => asyncomplete


command Rename  :LspRename
command FixIt   :LspCodeAction
command Format  :LspDocumentFormat
command SignsHelp :LspSignatureHelp
command SymbolList :LspDocumentSymbol
command Diagnostics :LspDocumentDiagnostics
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

nnoremap K  :LspHover<cr>
nnoremap gr :LspReferences<cr>
nnoremap gd :LspDefinition<cr>
nnoremap gD :LspDeclaration<cr>
nnoremap gi :LspImplementation<cr>
nnoremap rn :LspRename<cr>
nnoremap ca :LspCodeAction<cr>
nnoremap ge :LspNextDiagnostic<cr>
nnoremap gp :LspPreviousDiagnostic<cr>
nnoremap fmt :LspDocumentFormating<cr>

inoremap <expr> <CR> pumvisible() ? asyncomplete#close_popup() : "\<cr>"

inoremap <expr> <TAB> pumvisible() ? "\<C-n>" :
  \ vsnip#jumpable(1) ? '<Plug>(vsnip-jump-next)' :
  \ "\<TAB>"

"  \ asyncomplete#force_refresh() " may slow down

inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" :
  \ vsnip#jumpable(-1) ? '<Plug>(vsnip-jump-prev)' :
  \ "\<C-h>"

let g:lsp_signature_help_delay = 1000           " avoid signature help splash
let g:lsp_diagnostics_float_cursor = 1          " open float window show diagnostics info
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_diagnostics_signs_insert_mode_enabled = 0 " disable signature signs when insert mode
let g:lsp_diagnostics_highlights_insert_mode_enabled = 0

call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'allowlist': ['*'],
    \ 'blocklist': ['go'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ 'config': {
    \    'max_buffer_size': 5000000,
    \  },
    \ }))
au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'allowlist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))
