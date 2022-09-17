" >>>>>>>>>>>>>>>>>>> config leaderF >>>>>>>>>>>>>>>>>>>>>>
let g:Lf_HideHelp = 1
let g:Lf_WildIgnore = {
      \ 'dir': ['.svn','.git','.hg', '*build*', '.clangd', '.vscode', '*blade*'],
      \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
      \}

let g:Lf_ShortcutF = '<c-p>'
let g:Lf_ShortcutB = '<leader>fb'
noremap <leader>fr :LeaderfMru<CR>
noremap <leader>fb :LeaderfBuffer<CR>
noremap <leader>ff :LeaderfFunction<CR>

if executable("rg")
  noremap  <leader>tq :<C-U>Leaderf! rg --recall<CR>
  noremap  <leader>fc :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>
  xnoremap <leader>fv :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR>
  noremap  <leader>fcb :<C-U><C-R>=printf("Leaderf! rg -F --current-buffer -e %s ", expand("<cword>"))<CR>
else
  set wildchar=<Tab> wildmenu wildmode=full
  nnoremap <leader>fc :AsyncRun grep -rwn <cword> . <CR>
  nnoremap <leader>tq :call asyncrun#quickfix_toggle(8)<cr>
endif
" <<<<<<<<<<<<<<<<<<<<< end leaderF <<<<<<<<<<<<<<<<<<<<<<<
