" Colors, highlighting, colorscheme, etc                                 {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set background=dark

" turning off bg in the terminal allows the bg to be transparent
if has('gui_running')
  let g:colors_keep_transparent_bg = v:false " gvim can't have transparent bg
elseif $TERMUX_VERSION =~ '\d'
  let g:colors_keep_transparent_bg = v:false " termux can't have transparent bg
else
  let g:colors_keep_transparent_bg = v:true
endif

if g:colors_keep_transparent_bg
  if !exists('g:jellybeans_overrides')
    let g:jellybeans_overrides = {}
    let g:jellybeans_overrides['background'] = {}
  endif
  let g:jellybeans_overrides['background']['guibg']      = 'NONE'
  let g:jellybeans_overrides['background']['ctermbg']    = 'NONE'
  let g:jellybeans_overrides['background']['256ctermbg'] = 'NONE'
  let g:solarized_termtrans = 1

  augroup vimrc_transparent_bg
    autocmd!
    autocmd ColorScheme * hi Normal  ctermbg=NONE guibg=NONE
    autocmd ColorScheme * hi NonText ctermbg=NONE guibg=NONE
  augroup END

else
  let g:tempus_enforce_background_color = v:true " tempus bg is off by default
  let g:solarized_termtrans = 0
endif

" highlight current line, but only in active window
augroup CursorLineOnlyInActiveWindow
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
augroup END

" n.b: colorscheme plugins are stored in ~/.vim/pack/colorschemes
" TODO: load local colorscheme override
try
  " colorscheme torte
  " colorscheme PaperColor
  " colorscheme tempus_warp
  " colorscheme tempus_night
  " colorscheme SlateDark

  " my default for years... with 256 colors. not as good with 24bit color :(
  " colorscheme inkpot

  " let g:solarized_hitrail=1
  " colorscheme solarized8_dark_high

  " packadd! onedark.vim
  " colorscheme onedark
  " g:airline_theme='onedark'

  " packadd! vim-one
  " colorscheme one
  " let g:airline_theme='one'

  " let g:gruvbox_italic=1
  " let g:gruvbox_contrast_dark='hard'
  " colorscheme gruvbox
  " let g:airline_theme='gruvbox'

  colorscheme tempus_warp

catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
