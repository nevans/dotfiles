" Nicholas A. Evans's vimrc
"
" I've been using some parts of this config since 1997... it might be there are
" better ways to configure vim in 2022. ;)
"
" Nota Bene: This vimrc requires at least vim 8.0
"
" Some config has been moved to ~/.vim/{after,plugins,ftdetect} (etc)
"  * plugin management is handled in ~/.vim/plugins/packager.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Defaults                                                               {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set unconditionally, to set various options to their default vim values.
" This reverts some OS overrides, e.g. debian turns off 'modeline'.
set nocompatible

" Starting with 7.4.2111 & 8.0. vim's defaults were much improved.  However
" "defaults.vim" isn't auto-loaded when vimrc is present.  Of course, I didn't
" learn about defaults.vim until many years later... (2022)!  :)
"
" The next most important baseline settings are in "sensible.vim".
"
" In 2022, I *finally* removed my own redundant settings from this file.
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim
runtime! plugin/sensible.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set paths to XDG Base Directory Specification                          {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" $MYVIMRC is normally set by vim... except when VIMINIT is used.
if empty($MYVIMRC) | let $MYVIMRC = expand('<sfile>:p') | endif

" these *should* be set by the shell initialization, but just in case:
if empty($XDG_CACHE_HOME)  | let $XDG_CACHE_HOME=$HOME..'/.cache'       | endif
if empty($XDG_CONFIG_HOME) | let $XDG_CONFIG_HOME=$HOME..'/.config'     | endif
if empty($XDG_DATA_HOME)   | let $XDG_DATA_HOME=$HOME..'/.local/share'  | endif
if empty($XDG_STATE_HOME)  | let $XDG_STATE_HOME=$HOME..'/.local/state' | endif

" ~/.config takes priority over ~/.local/share
set runtimepath^=$XDG_DATA_HOME/vim
set runtimepath+=$XDG_DATA_HOME/vim/after
set runtimepath^=$XDG_CONFIG_HOME/vim
set runtimepath+=$XDG_CONFIG_HOME/vim/after

set packpath^=$XDG_DATA_HOME/vim
set packpath+=$XDG_DATA_HOME/vim/after
set packpath^=$XDG_CONFIG_HOME/vim
set packpath+=$XDG_CONFIG_HOME/vim/after

" Move swapfiles, persistent undofile, view files, backup files.
"
" From :help 'directory'
"       For Unix and Win32, if a directory ends in two path separators "//",
"       the swap file name will be built from the complete path to the file
"       with all path separators replaced by percent '%' signs (including
"       the colon following the drive letter on Win32). This will ensure
"       file name uniqueness in the preserve directory.

set backupdir   =$XDG_DATA_HOME/vim/backup//,~/.vim/backup//
set viewdir     =$XDG_DATA_HOME/vim/view

let g:netrw_home      = $XDG_DATA_HOME..'/vim'
let g:coc_config_home = $XDG_CONFIG_HOME..'/vim'

set directory  =$XDG_STATE_HOME/vim/swap//,~/.vim/swap//
set undodir    =$XDG_STATE_HOME/vim/undo//,~/.vim/undo//
set viminfofile=$XDG_STATE_HOME/vim/viminfo

try
  call mkdir($XDG_DATA_HOME..'/vim/backup', 'p', 0700)
  call mkdir($XDG_DATA_HOME.."/vim/spell",  'p', 0700)
  call mkdir($XDG_DATA_HOME..'/vim/view',   'p', 0700)

  call mkdir($XDG_STATE_HOME..'/vim/swap',  'p', 0700)
  call mkdir($XDG_STATE_HOME..'/vim/undo',  'p', 0700)

  set undofile
catch
endtry

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Local initialization (machine or private config) .config/vim/vimrc     {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if filereadable($XDG_CONFIG_HOME..'/vim/vimrc')
  source $XDG_CONFIG_HOME..'/vim/vimrc'
endif
if filereadable($XDG_DATA_HOME..'/vim/vimrc')
  source $XDG_DATA_HOME..'/vim/vimrc'
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Basic config                                                           {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" I used comma as mapleader for two decades.  When I got a keyboard with a
" better '\' key placement, I switched to the default for a little while: it is
" nice for the opposite of ';' to work!  But, I think <space> is probably best!
"
let mapleader = "\<Space>"
let maplocalleader = ','
" But I *would* like the opposite of ';' to work!  So that's double-comma.
noremap  <localleader>, ,

" " set this low so map prefixes can run sooner
" set timeoutlen=500

set showtabline=2       " always show tabline
set cmdheight=2         " avoids some unnecessary <hit-enter> prompts
set shortmess=atIoO     " abbreviate and truncate messages, avoiding 'hit enter' prompts
set shortmess+=c        " coc.nvim says: Don't pass messages to |ins-completion-menu|

set wildmode=list:longest,full

set completeopt=menu,menuone,popup

if has('multi_byte') && &encoding ==# 'utf-8'
  set fillchars+=vert:║
endif
" see also after/plugin/auto-origami

set updatetime=200      " default of 4000 doesn't play as well with coc.nvim

set hlsearch            " highlight all searches
set magic               " use vim-style regex excaping

set visualbell          " beeps are annoying; flashes less so.

set virtualedit=block   " lets me place cursor *anywhere* in visual block mode
set autoread            " autoread changed files; not triggered if the internal modifications

set number              " nice to know what line number I'm on

" show line numbers relative to current line  {{{2
" BUT, only in current buffer, and not in insert mode.
" set relativenumber      " trying out relative numbers (shows current number)
" augroup numbertoggle
"   autocmd!
"   autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
"   autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
" augroup END " }}}2

set foldlevelstart=99   " always start unfolded

set list                " show tabs and trailing whitespace explicitly
set listchars=trail:_,tab:>-,precedes:<,extends:>

set splitbelow          " For some reason, the default split options
set splitright          " (left and above) usually feel backwards to me.

" Arguably, the following group of settings belong in editorconfig or ftplugin.
" But these are my preferred defaults, when ftplugin doesn't specify.
set shiftwidth=2        " use two spaces per indent level
set expandtab           " and always use spaces rather than tabs
set tabstop=8           " but show me tab chars as great big 8-spaced monsters
set textwidth=80

" it took me a weirdly long time to come around to this setting.
" I was still unsure about it when vim 7.3 was released! (early 2010s)  ;)
set hidden              " hide (instead of unload) buffers when they are abandoned

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Terminal or window width options                                       {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

augroup vimrc_resize_options
  au!
  au VimEnter,VimResized,BufWinEnter * call s:adjust_options_for_width()

  function s:adjust_options_for_width()

    if 100 <= &columns
      " wide enough to support all of my preferred features
      set nowrap                        " don't use line-wrapping by default
      set numberwidth=5                 " spacious
      set signcolumn=yes                " always display sign column
      let g:auto_origami_foldcolumn = 5 " spacious

    elseif 90 <= &columns
      " narrow, but usable
      set wrap                          " narrow screens need to wrap
      set numberwidth=4                 " good enough for most files
      set signcolumn=number             " merged sign and number columns
      let g:auto_origami_foldcolumn = 2 " not much!

    elseif 85 <= &columns
      " too narrow for everything
      set wrap                          " narrow screens need to wrap
      set numberwidth=1                 " use only as much space as necessary
      set signcolumn=number             " merged sign and number columns
      let g:auto_origami_foldcolumn = 1 " nearly nothing

    else
      " very narrow screen
      set wrap                          " narrow screens need to wrap
      set numberwidth=1                 " use only as much space as necessary
      set signcolumn=number             " merged sign and number columns
      let g:auto_origami_foldcolumn = 0 " no foldcolumn
    endif

  endfunction

augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TERM/TERMINFO/COLORTERM, mouse, tmux, etc                              {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if !has('gui_running')

  " Scroll only one line for mouse wheel events to get smooth scrolling on touch screens
  map  <ScrollWheelUp>   <C-Y>
  imap <ScrollWheelUp>   <C-X><C-Y>
  map  <ScrollWheelDown> <C-E>
  imap <ScrollWheelDown> <C-X><C-E>

  if &mouse =~# 'a'
    set mouse-=a     " some terminals won't or can't override app mouse control
    set mouse+=nvi   " let terminal control mouse (& clipboard) in command mode
  endif

  if &term =~ '^\%(screen\|tmux\)'
      " Better mouse support, see  :help 'ttymouse'
      set ttymouse=sgr

      " Enable bracketed paste mode, see  :help xterm-bracketed-paste
      let &t_BE = "\<Esc>[?2004h"
      let &t_BD = "\<Esc>[?2004l"
      let &t_PS = "\<Esc>[200~"
      let &t_PE = "\<Esc>[201~"

      " Enable focus event tracking, see  :help xterm-focus-event
      let &t_fe = "\<Esc>[?1004h"
      let &t_fd = "\<Esc>[?1004l"
      execute "set <FocusGained>=\<Esc>[I"
      execute "set <FocusLost>=\<Esc>[O"

      " Enable modified arrow keys, see  :help arrow_modifiers
      execute "silent! set <xUp>=\<Esc>[@;*A"
      execute "silent! set <xDown>=\<Esc>[@;*B"
      execute "silent! set <xRight>=\<Esc>[@;*C"
      execute "silent! set <xLeft>=\<Esc>[@;*D"
  endif

  if $COLORTERM =~ '^\%(truecolor\|24bit\)$' || $TERM =~# '-direct$'
    " 256 colors (not 16M) because t_Co is for the *palette* of *indexed* colors
    " i.e. it's the difference between setaf/setab and setrgbf/setrgbb.
    " At least, that's how ncurses and tput interpret it. vim may be different?
    if empty(&t_Co) | let &t_Co = 256 | endif
    " these are only set automatically for xterm-*... :(
    if empty(&t_8f) | let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" | endif
    if empty(&t_8b) | let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum" | endif
    let &termguicolors = v:true
  endif

endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

" warn me when I've gone over the textwidth
let &colorcolumn="+1,+21,+41,+61,+81"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Abbreviations                                                          {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

iabbrev Lidsa     Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum

" Plugin configurations                                                 {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: airline                                          {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" let g:airline_experimental = 1  " enable new vim9 implementation

let g:airline#extensions#tabline#show_buffers            = 1
let g:airline#extensions#tabline#buf_label_first         = 1
let g:airline#extensions#tabline#buffers_label           = 'bufs'
let g:airline#extensions#tabline#enabled                 = 1
let g:airline#extensions#tabline#show_tab_nr             = 1
let g:airline#extensions#tabline#show_tab_type           = 1
let g:airline#extensions#tabline#switch_buffers_and_tabs = 1
let g:airline#extensions#tabline#tab_nr_type             = 2 " splits and tab number
let g:airline#parts#ffenc#skip_expected_string           = 'utf-8[unix]'

let g:airline_exclude_preview                            = 0
let g:airline_powerline_fonts                            = 1
let g:airline_section_c_only_filename                    = 0
let g:airline_skip_empty_sections                        = 1
let g:airline_symbols_ascii                              = 0

" NB: no*, cv, ce, r? and ! do not actually display
"  I added extra space where either vim or my terminal were ignorant of double
"  wide characters.
let g:airline_mode_map = {
      \ '__':    '----',
      \ 'n':     'N✅',  'c':   'C:…',
      \ 'i':     'I📝',  'ic':  'I🎱',  'ix':  'I🔮',
      \ 'R':     'R📝',  'Rc':  'R🎱',  'Rx':  'R🔮',
      \ 's':     'S……',  'S':   'S☰☰',  '':  'S▒▒',
      \ 'v':     'V……',  'V':   'V☰☰',  '':  'V▒▒',
      \ 't':     'T💻',  'nt':  'N💻',
      \ 'multi': 'M🎛️',
      \ 'Rv':    'Rv📝', 'Rvc': 'Rv🎱', 'Rvx': 'Rv🔮',
      \ 'niI':   'N<<I', 'niR': 'N<<R', 'niV': 'N<<V',
      \ 'vs':    'V…<S', 'Vs':  'V☰<S', 's': 'V▒<S',
      \ }

" my symbols
" copied and pasted from :help airline-customization
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

" shrink to single char, removing superfluous whitespace and ':'
let g:airline_symbols.linenr    = ''
let g:airline_symbols.colnr     = ''
let g:airline_symbols.maxlinenr = '☰'

" emoji > powerline or other nerd font symbols
" n.b. vim-emoji-icon-theme plugin sets many of these too...
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
" Plugin: ale                                              {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" let g:ale_disable_lsp = 1 " let coc.nvim handle LSP

if !exists('g:ale_linters')         | let g:ale_linters = {}         | endif
if !exists('g:ale_fixers')          | let g:ale_fixers = {}          | endif
if !exists('g:ale_pattern_options') | let g:ale_pattern_options = {} | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ALE: ruby config                                     {{{3
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:ale_ruby_brakeman_executable   = 'bundle'
let g:ale_ruby_reek_executable       = 'bundle'
let g:ale_ruby_rubocop_executable    = 'bundle'
let g:ale_ruby_standardrb_executable = 'bundle'

let g:ale_linters["ruby"] = [
      \ 'ruby',
      \ 'rubocop',
      \ 'solargraph',
      \ 'reek',
      \]
" let g:ale_linters["ruby"] = ['sorbet']
" let g:ale_linters["ruby"] += ['rails_best_practices']

" let g:ale_fixers["ruby"] += ["remove_trailing_lines", "trim_whitespace"]
" let g:ale_fixers["ruby"] += ["rubocop"]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: coc.nvim                                         {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:coc_global_extensions = [
      \ '@yaegassy/coc-ansible',
      \ 'coc-clangd',
      \ 'coc-clang-format-style-options',
      \ 'coc-css',
      \ 'coc-diagnostic',
      \ 'coc-emoji',
      \ 'coc-eslint',
      \ 'coc-fzf-preview',
      \ 'coc-go',
      \ 'coc-gocode',
      \ 'coc-html',
      \ 'coc-json',
      \ 'coc-lists',
      \ 'coc-solargraph',
      \ 'coc-tsserver',
      \ 'coc-vimlsp',
      \ 'coc-yaml',
      \ ]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: fzf and fzf.vim                                  {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" use vim 8.2 popup windows! (yay!)
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: ack.vim                                          {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ackprg='ag --nogroup --nocolor --column'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: netrw                                            {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:netrw_liststyle=3 " tree style

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: bufexplorer                                      {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:bufExplorerShowRelativePath=1  " Show relative paths.
let g:bufExplorerSortBy='mru'        " Sort by MRU (cycle other sorts: s or S)
let g:bufExplorerSplitOutPathName=1  " Split the path and file name.
let g:bufExplorerSplitVertSize=0     " New split window cols (0 is set by Vim)
let g:bufExplorerSplitHorzSize=0     " New split window rows (0 is set by Vim)
let g:bufExplorerSplitRight=0        " Split left.
let g:bufExplorerFindActive=0        " Do not go to active window. (toggle: a)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" End plugin configs ....                                }}}1
" FT plugin configurations (TODO: move to ftplugins)                     {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ftplugin: ruby-vim                                       {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ruby_indent_assignment_style = 'variable'
let ruby_fold                      = 1
let ruby_foldable_groups           = 'module class def do __END__'
let ruby_minlines                  = 250
let ruby_operators                 = 1
let ruby_pseudo_operators          = 1
let ruby_space_errors              = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ftplugin: markdown                                       {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" syntax highlighting in code blocks:
let g:markdown_fenced_languages = ['ruby', 'html', 'bash=sh']
let g:markdown_folding_level = 6

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ftplugin: vim-json                                       {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vim_json_syntax_conceal = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" End ftplugin configs ....                                }}}1
" Custom mappings                                                        {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings: UI                                                 (nmap)    {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" because I often accidentally hit F1, and I know how to use :help
noremap           <F1>   <Esc>
noremap!          <F1>   <Esc>

" quickly turn off search highlighting
noremap <leader><cr> :nohl<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings: colors and syntax highlighting...                  (nmap)    {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" copied from https://stackoverflow.com/questions/9464844/how-to-get-group-name-of-highlighting-under-cursor-in-vim
function! SynStack ()
  for i1 in synstack(line("."), col("."))
    let i2 = synIDtrans(i1)
    let n1 = synIDattr(i1, "name")
    let n2 = synIDattr(i2, "name")
    echo n1 "->" n2
  endfor
endfunction

" this will help remove syntax highlighting errors that result from not having
" enough context cached... but it might be slow
noremap <leader>$$   :syntax sync fromstart<cr>
noremap <leader>$256 :set t_Co=256<cr>
noremap <leader>$16  :set t_Co=16<cr>
"autocmd BufEnter * :syntax sync fromstart

" occasionally I might want to toggle syntax highlighting...
" mneumonic:$yntax Yes
noremap <leader>$y :syntax on<cr>
" mneumonic:$yntax No
noremap <leader>$n :syntax off<cr>

" replaces g?{motion} => rot13
nnoremap g? :call SynStack()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" identify syntax highlighting group at the cursor (VimTip 99)
nnoremap <leader>hlid :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings: navigation inside buffers                          (nmap)    {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Emacs style mappings
inoremap <C-A> <C-O>^
cnoremap <C-A> <Home>

" when wrap is on, only navigate over *screen* lines, not actual lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings: navigation between files and buffers               (nmap)    {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" use arrow keys for quick buffers/clist navigation
" I go back and forth on whether I love this or hate it.
" It only seems to be an issue when plugins expect working arrow keys.
"
" Oh, and its a real pain when using a phone keyboard, eg TERMUX.
if $TERMUX_VERSION !~ '\d'
  nnoremap <left>  :bp<cr>
  nnoremap <right> :bn<cr>
  nnoremap <up>    :cp<cr>
  nnoremap <down>  :cn<cr>
endif

" use vim-win for quick window movement: <leader>w then arrow keys or numbers
" use tmux-navigator for quick window movement: <C-h><C-j><C-k><C-l>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings: window and tab navigation                          (nmap)    {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" quickly open command line with...
" split window (horizontally)
nnoremap <leader>sh :split ~/
nnoremap <leader>sc :split ./
nnoremap <leader>sj :stj<space>
nnoremap <leader>sb :buffers<cr>:sbuffer<space>
" split window vertically
nnoremap <leader>vh :vsplit ~/
nnoremap <leader>vc :vsplit ./
nnoremap <leader>vj :vert stj<space>
nnoremap <leader>vb :buffers<cr>:vert sbuffer<space>
" create new tab
nnoremap <leader>th :tabnew ~/
nnoremap <leader>tc :tabnew ./
nnoremap <leader>tj :tab stj<space>
nnoremap <leader>tb :buffers<cr>:tab sbuffer<space>
" and quick tab links to important files...
nnoremap <leader>tV :tabnew ~/.vimrc<cr>
nnoremap <leader>tB :tabnew ~/.bashrc<cr>
nnoremap <leader>tT :tabnew ~/Documents/TODO<cr>
nnoremap <leader>tJ :tabnew ~/Documents/work/journal.md<cr>
" in current window
nnoremap <leader>eh :e ~/
nnoremap <leader>ec :e ./
nnoremap <leader>ej :tj<space>
nnoremap <leader>eb :buffers<cr>:buffer<space>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings: visual mode                                        (vmap)    {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable TAB indent and SHIFT-TAB unindent
"inoremap <S-TAB> <C-O><<
vnoremap <silent> <TAB>   >gv
vnoremap <silent> <S-TAB> <gv

" quick search for visual selection
vnoremap / y/<C-R>"<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings: command mode                                       (cmap)    {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" quick dirname in command mode
cnoremap %% <c-r>=expand('%:h').'/'<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings: vim-which-key                                                {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-which-key plugin: provides dynamically generated menu from mappings
nnoremap <silent> <leader>      :<c-u>WhichKey       '<Space>'<CR>
vnoremap <silent> <leader>      :<c-u>WhichKeyVisual '<Space>'<CR>
nnoremap <silent> <localleader> :<c-u>WhichKey       ','<CR>
vnoremap <silent> <localleader> :<c-u>WhichKeyVisual ','<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings: fzf and fzf.vim                                              {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <c-p> :GitFiles<CR>
" These mappings are taken from :help fzf-vim

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)
" Path completion with custom source command
"
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('fd')
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files')

" Word completion with custom spec with popup layout option
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings: NERDTree                                           (cmap)    {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" open/close file browser
nmap <leader>d :NERDTreeToggle<CR>
" open file browser rooted in current file's dir
nmap <leader>D :NERDTree %<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Local overrides (machine or private config) .config/vim/after/vimrc    {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if filereadable($XDG_DATA_HOME..'/vim/after/vimrc')
  source $XDG_DATA_HOME..'/vim/after/vimrc'
endif
if filereadable($XDG_CONFIG_HOME..'/vim/after/vimrc')
  source $XDG_CONFIG_HOME..'/vim/after/vimrc'
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim modeline... {{{1
" vim: wrap fdm=marker
