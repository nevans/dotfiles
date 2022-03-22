runtime! plugin/sensible.vim

set number
set laststatus=2
set showtabline=2

set background=dark
set termguicolors
let g:tempus_enforce_background_color=1
" colorscheme tempus_warp
colorscheme tempus_night

let g:jellybeans_overrides = {
\  'background': {
\    'ctermbg': 'none', '256ctermbg': 'none',
\  },
\}

if has('termguicolors') && &termguicolors
    let g:jellybeans_overrides['background']['guibg'] = 'none'
endif
" colorscheme torte
" colorscheme PaperColor

let g:markdown_fenced_languages = ['ruby']
let g:airline_statusline_ontop=1
let g:airline#extensions#tabline#enabled = 1
let ruby_operators = 1
let ruby_space_errors = 1
let ruby_minlines = 100
