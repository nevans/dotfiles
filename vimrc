" Nicholas A. Evans's vimrc
"
" I've been using some parts of this config since 1997... it might be there are
" better ways to configure vim in 2022. ;)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic editor config                                                    {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" The most important "baseline" settings are in "sensible.vim".  So I've
" (mostly) removed setting those values explicitly, below.
runtime! plugin/sensible.vim

" I used comma as mapleader for two decades.  When I got a keyboard with a
" better '\' key placement, I switched to the default for a little while: it is
" nice for the opposite of ';' to work!  But, I think <space> is probably best!
"
" let mapleader=","
let mapleader = " "

set showcmd             " always show the partial command in progress, below the status line
set showtabline=2       " always show tabline
set cmdheight=2         " avoids some unnecessary <hit-enter> prompts
set shortmess=atIoO     " abbreviate and truncate messages, avoiding 'hit enter' prompts
set shortmess+=c        " coc.nvim says: Don't pass messages to |ins-completion-menu|

set nowrap              " don't use line-wrapping by default
set number              " nice to know what line number I'm on

set list                " show tabs and trailing whitespace explicitly
set listchars=trail:_,tab:>-,precedes:<,extends:>

set foldlevelstart=99   " always start unfolded

" show line numbers relative to current line  {{{2
" BUT, only in current buffer, and not in insert mode.
" set relativenumber      " trying out relative numbers (shows current number)
" augroup numbertoggle
"   autocmd!
"   autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
"   autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
" augroup END " }}}2

" and don't bounce around for the sign column; override the number column
" but fallback to permanent signcolumn for older versions of vim
if has('signs')
  set signcolumn=yes
  silent! set signcolumn=number
endif

set wildmode=list:longest,full
set completeopt=menu,menuone,popup

set updatetime=200      " default of 4000 doesn't play as well with coc.nvim

set hlsearch            " highlight all searches
set incsearch           " shows results before hitting enter
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

" As of version 8, vim enables the mouse by default - but only if no ~/.vimrc
" is found. Enable that unconditionally for Termux as it's useful with touch:
set mouse=a

" Scroll only one line for mouse wheel events to get smooth scrolling on touch screens
map <ScrollWheelUp> <C-Y>
imap <ScrollWheelUp> <C-X><C-Y>
map <ScrollWheelDown> <C-E>
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

" from :help last-position-jump
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g'\"" | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Colors, highlighting, colorscheme, etc                                 {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin configs                                                         {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:markdown_fenced_languages = ['ruby']

let g:airline_statusline_ontop=1
let g:airline#extensions#tabline#enabled = 1

let ruby_operators = 1
let ruby_space_errors = 1
let ruby_minlines = 100

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
