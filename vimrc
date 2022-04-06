" Nicholas A. Evans's vimrc
"
" I've been using some parts of this config since 1997... it might be there are
" better ways to configure vim in 2022. ;)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic editor config                                                    {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Starting with 7.4.2111 & 8.0. vim's defaults were much improved.  However
" "defaults.vim" isn't auto-loaded when vimrc is present., since vim 8.0.  Of
" course, I diidn't learn about that until six years later... (2022)!
"
" The next most important "baseline" settings are in "sensible.vim".
" rWhere the two overlap, I'll mostly prefer "sensible.vim".
"
" In 2022, I *finally* removed my own redundant settings from this file.
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim
runtime! plugin/sensible.vim

" I used comma as mapleader for two decades.  When I got a keyboard with a
" better '\' key placement, I switched to the default for a little while: it is
" nice for the opposite of ';' to work!  But, I think <space> is probably best!
"
" let mapleader=","
let mapleader = " "

set showtabline=2       " always show tabline
set cmdheight=2         " avoids some unnecessary <hit-enter> prompts
set shortmess=atIoO     " abbreviate and truncate messages, avoiding 'hit enter' prompts
set shortmess+=c        " coc.nvim says: Don't pass messages to |ins-completion-menu|

set nowrap              " don't use line-wrapping by default
set number              " nice to know what line number I'm on

set list                " show tabs and trailing whitespace explicitly
set listchars=trail:_,tab:>-,precedes:<,extends:>

set foldlevelstart=99   " always start unfolded

set signcolumn=yes      " managed dynamically via plugin/dynamic_signs.vim

set wildmode=list:longest,full
set completeopt=menu,menuone,popup

set updatetime=200      " default of 4000 doesn't play as well with coc.nvim

set hlsearch            " highlight all searches
set magic               " use vim-style regex excaping

set visualbell          " beeps are annoying; flashes less so.

set virtualedit=block   " lets me place cursor *anywhere* in visual block mode

set splitbelow          " For some reason, the default split options
set splitright          " (left and above) usually feel backwards to me.

" it took me a weirdly long time to come around to this setting.  ;)
set hidden              " hide (instead of unload) buffers when they are abandoned

" Arguably, the following group of settings belong in editorconfig or ftplugin.
" But these are my preferred defaults, when ftplugin doesn't specify.
set shiftwidth=2        " use two spaces per indent level
set smarttab            " and use the shiftwidth for <Tab>/<BS> at begining of line
set expandtab           " and always use spaces rather than tabs
set tabstop=8           " but show me tab chars as great big 8-spaced monsters
set textwidth=80

" Scroll only one line for mouse wheel events to get smooth scrolling on touch screens
map  <ScrollWheelUp>   <C-Y>
imap <ScrollWheelUp>   <C-X><C-Y>
map  <ScrollWheelDown> <C-E>
imap <ScrollWheelDown> <C-X><C-E>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" State config                                                           {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" !: Save and restore global variables that start with an uppercase letter, and don't contain a lowercase letter.
" ': Maximum number of previously edited files for which the marks are remembered.
" <: Maximum number of lines saved for each register.
" s: Maximum size of an item in Kbyte.  If zero then registers are
" %: saves and restores the buffer list
" h: Disable the effect of 'hlsearch' when loading the viminfo file.
set viminfo=!,'20,<100,s15,%,h

set exrc   " allow loading project specific .vimrc, but securely!
set secure " ":autocmd", shell and write commands are not allowed in ".vimrc" in
           " the current directory and map commands are displayed.

" Move swapfiles, persistent undofile, and backup files
try
    set directory=~/.vim/swap/,~/tmp/,tmp,/tmp/,.
    set undodir=~/.vim/undo/
    set backupdir=~/.vim/backup/,~/tmp/,tmp,/tmp/,.
    set undofile
catch
endtry

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors, highlighting, colorscheme, etc                                 {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set background=dark
set termguicolors
let g:tempus_enforce_background_color=1

" n.b: colorschemes are stored in ~/.vim/pack/colorschemes
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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin configs                                                         {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: airline                                          {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" let g:airline_experimental = 1  " enable new vim9 implementation

let g:airline#extensions#tabline#enabled = 1
let g:airline_exclude_preview = 0
let g:airline_section_c_only_filename = 0
let g:airline_powerline_fonts = 1
let g:airline_symbols_ascii = 0

" NB: no*, cv, ce, r? and ! do not actually display
"  I added extra space where either vim or my terminal were ignorant of double
"  wide characters.
let g:airline_mode_map = {
      \ '__':    '----',
      \ 'n':     'N ✅', 'c':   'C :…',
      \ 'i':     'I 📝', 'ic':  'I 🎱', 'ix':  'I 🔮',
      \ 'R':     'R 📝', 'Rc':  'R 🎱', 'Rx':  'R 🔮',
      \ 'Rv':    'Rv📝', 'Rvc': 'Rv🎱', 'Rvx': 'Rv🔮',
      \ 'niI':   'N<<I', 'niR': 'N<<R', 'niV': 'N<<V',
      \ 's':     'S ……', 'S':   'S ☰☰', '':  'S ▒▒',
      \ 'vs':    'V…<S', 'Vs':  'V☰<S', 's': 'V▒<S',
      \ 'v':     'V ……', 'V':   'V ☰☰', '':  'V ▒▒',
      \ 't':     'T 💻', 'nt':  'N 💻',
      \ 'multi': 'M 🎛️ ',
      \ }

" my symbols
" opied and pasted from :help airline-customization
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" shrink to single char, removing superfluous whitespace and ':'
let g:airline_symbols.linenr    = ''
let g:airline_symbols.colnr     = ''
let g:airline_symbols.maxlinenr = '☰'

# emoji > powerline or other nerd font symbols
let g:airline_symbols.spell    = '📖'   " see, it's a dictionary...
let g:airline_symbols.paste    = '📋'   " from the clipboard
let g:airline_symbols.readonly = '🔒✍️' " locked from writing
let g:airline_symbols.crypt    = '🔓🔑' " unlocked with keyboard

let g:airline#extensions#branch#format   = 1 " feature/foo -> foo
let g:airline#extensions#branch#sha1_len = 6

" TODO: fix unreadably low contrast of inactive splits
" TODO: fix skinny width components
" TODO: slimmer linenr, maxlinenr, colnr

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TODO: move ft configs to ftplugins                       {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:markdown_fenced_languages = ['ruby']

let ruby_operators = 1
let ruby_space_errors = 1
let ruby_minlines = 100

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom mappings                                                        {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable TAB indent and SHIFT-TAB unindent
"inoremap <S-TAB> <C-O><<
vnoremap <silent> <TAB>   >gv
vnoremap <silent> <S-TAB> <gv

" quick search for visual selection
vnoremap / y/<C-R>"<CR>

" quick dirname in command mode
cnoremap %% <c-r>=expand('%:h').'/'<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Local customizations (per-machine or private config)                   {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" local customizations in ~/.vimrc_local
let $LOCALFILE=expand("~/.vimrc_local")
if filereadable($LOCALFILE)
  source $LOCALFILE
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim modeline... {{{1
" vim: wrap fdm=marker
