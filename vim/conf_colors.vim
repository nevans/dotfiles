" Colors, highlighting, colorscheme, etc
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Load color config vars                                                 {{{1
" n.b: color vars should be set in ~/.config/vim/conf_colors.vim
" The values here are just defaults.

let g:vimrc_colorscheme = get(g:, 'vimrc_colorscheme', {})
let s:name       = get(g:vimrc_colorscheme, 'name', 'tempus_warp')
let s:pack       = get(g:vimrc_colorscheme, 'pack')
let s:airline    = get(g:vimrc_colorscheme, 'airline', 'onedark')
let s:background = get(g:vimrc_colorscheme, 'background', 'dark')

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" colorscheme config vars                                                {{{1
" TODO: make these overrideable defaults

let g:gruvbox_italic=1
let g:gruvbox_contrast_dark='hard'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" transparent background config                                          {{{1
" TODO: make these overrideable defaults

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" UI elements (e.g. colorcolumn)                                         {{{1

" warn me when I've gone over the textwidth
let &colorcolumn="+1,+21,+41,+61,+81"

" highlight current line, but only in active window
augroup CursorLineOnlyInActiveWindow
    autocmd!
    autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
    autocmd WinLeave * setlocal nocursorline
augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set the colorscheme (and other theme vars) from the config above...    {{{1
"
" n.b: colorscheme plugins are stored in ~/.vim/pack/colorschemes

try
  let &background = s:background
  if !empty(s:pack)    | exe 'packadd!'    s:pack        | endif
  if !empty(s:name)    | exe 'colorscheme' s:name        | endif
  if !empty(s:airline) | let g:airline_theme = s:airline | endif
catch /^Vim\%((\a\+)\)\=:E185/
  " if there are errors, just revert to default...
  set background=dark
  colorscheme default
endtry

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}1
" vim modeline... {{{1
" vim: wrap fdm=marker
