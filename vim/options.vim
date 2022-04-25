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
" Paths: swapfiles, persistent undofile, view files, backup files, etc.  {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}1
" vim: wrap fdm=marker
