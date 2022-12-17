
autocmd TerminalOpen * setlocal nonu
autocmd BufNewFile,BufRead *go setlocal noet ts=4 sw=4 sts=4
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

" back the last edit position when open a file
autocmd BufReadPost * if line("'\"") > 0|if line("'\"") <= line("$")|exe("norm '\"")|else|exe "norm $"|endif|endif
" >>>>>>>>>>>>>>>>>>>>> highlight end >>>>>>>>>>>>>>>>>>>>
