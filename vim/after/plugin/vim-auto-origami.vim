" Plugin: benknoble/vim-auto-origami

if !exists("g:loaded_auto_origami")
  finish
endif

let g:auto_origami_foldcolumn = 4
augroup autofoldcolumn
  au!
  au CursorHold,BufWinEnter,WinEnter * AutoOrigamiFoldColumn
augroup END
