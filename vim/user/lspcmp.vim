nnoremap K  :LspHover<cr>
nnoremap gr :LspReferences<cr>
nnoremap gd :LspDefinition<cr>
nnoremap gD :LspDeclaration<cr>
nnoremap gi :LspImplementation<cr>
nnoremap rn :LspRename<cr>
nnoremap ca :LspCodeAction<cr>
nnoremap gn :LspNextDiagnostic<cr>
nnoremap gp :LspPreviousDiagnostic<cr>

" > default mappings inspect tab key, so here change another
let g:UltiSnipsExpandTrigger='<c-s>'
"   g:UltiSnipsExpandTrigger               <tab>
"   g:UltiSnipsListSnippets                <c-tab>
"   g:UltiSnipsJumpForwardTrigger          <c-j>
"   g:UltiSnipsJumpBackwardTrigger         <c-k>

let g:lsp_signature_help_delay = 300           " avoid signature help splash
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_float_cursor = 0       " open float window show diagnostics info
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_diagnostics_signs_insert_mode_enabled=0 " disable signature signs when insert mode

let g:asyncomplete_auto_popup = 1
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr>    pumvisible() ? asyncomplete#close_popup() : "\<cr>"

"function! s:check_back_space() abort
"    let col = col('.') - 1
"    return !col || getline('.')[col - 1]  =~ '\s'
"endfunction
"inoremap <silent><expr> <TAB>
"  \ pumvisible() ? "\<C-n>" :
"  \ UltiSnips#CanJumpForwards() ? UltiSnips#JumpForwards() :
"  \ <SID>check_back_space() ? "\<TAB>" :
"  \ asyncomplete#force_refresh()
"
"inoremap <expr><S-TAB>
"  \ pumvisible() ? "\<C-p>" :
"  \ UltiSnips#CanJumpBackwards() ? UltiSnips#JumpBackwards() :
"  \ "\<C-h>"

call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'allowlist': ['*'],
    \ 'blocklist': ['go'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ 'config': {
    \    'max_buffer_size': 5000000,
    \  },
    \ }))
