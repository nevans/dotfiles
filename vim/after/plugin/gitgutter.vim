" This is needed when gitgutter loads before vim-emoji-icon-theme.

if exists('g:loaded_gitgutter') || !has('signs') || &cp
  call gitgutter#highlight#define_signs()
endif
