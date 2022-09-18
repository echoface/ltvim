" >>>>>>>>>>>>>>>>>>> config leaderF >>>>>>>>>>>>>>>>>>>>>>


let g:Lf_HideHelp = 1
let g:Lf_PreviewInPopup = 1
let g:Lf_WindowPosition = 'popup'
let g:Lf_WildIgnore = {
      \ 'dir': ['.svn','.git','.hg', '*build*', '.clangd', '.vscode', '*blade*'],
      \ 'file': ['*.sw?','~$*','*.bak','*.exe','*.o','*.so','*.py[co]']
      \}
let g:Lf_CommandMap = {'<C-K>': ['<Up>'], '<C-J>': ['<Down>']}

let g:Lf_ShortcutB = '<leader>fb'
let g:Lf_ShortcutF = "<leader>ff"
noremap <leader>fg :<C-U><C-R>=printf("Leaderf rg %s", "")<CR><CR>
noremap <leader>fm :<C-U><C-R>=printf("Leaderf mru %s", "")<CR><CR>
noremap <leader>ft :<C-U><C-R>=printf("Leaderf bufTag %s", "")<CR><CR>
noremap <leader>fl :<C-U><C-R>=printf("Leaderf line %s", "")<CR><CR>
noremap <leader>fc :<C-U><C-R>=printf("Leaderf command %s", "")<CR><CR>
noremap <leader>fs :<C-U><C-R>=printf("Leaderf function %s", "")<CR><CR>

if executable("rg")
  noremap  <leader>tq :<C-U>Leaderf! rg --recall<CR>
  xnoremap <leader>fv :<C-U><C-R>=printf("Leaderf! rg -F -e %s ", leaderf#Rg#visual())<CR>
  noremap  <leader>fw :<C-U><C-R>=printf("Leaderf! rg -e %s ", expand("<cword>"))<CR>
  noremap  <leader>fwb :<C-U><C-R>=printf("Leaderf! rg -F --current-buffer -e %s ", expand("<cword>"))<CR>
else
  set wildchar=<Tab> wildmenu wildmode=full
  nnoremap <leader>fw :AsyncRun grep -rwn <cword> . <CR>
  nnoremap <leader>tq :call asyncrun#quickfix_toggle(8)<cr>
endif
" <<<<<<<<<<<<<<<<<<<<< end leaderF <<<<<<<<<<<<<<<<<<<<<<<
