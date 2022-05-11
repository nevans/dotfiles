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

set wildmode=longest:full,full
if has("patch-8.2.4325")
  set wildoptions=pum,tagfile
endif

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
set display=lastline    " When lines are cropped at the screen bottom, show as much as possible
set autoread            " autoread changed files; not triggered if the internal modifications

set foldlevelstart=99   " always start unfolded

set list                " show tabs and trailing whitespace explicitly
set listchars=trail:_,tab:>-,precedes:<,extends:>
set colorcolumn=+1,+21,+41,+81,+161,+321,+641     " textwidth guard-rails

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

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" viminfo, and other saved state                                         {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

set viminfo=            " cleared here in order to set them one-by-one, below.
set viminfo+='100       " max files that will remember their marks.
set viminfo+=<250       " max lines saved per register.
set viminfo+=s50        " max kbyte saved per register, skipping any larger.
set viminfo+=h          " disable 'hlsearch' when loading the viminfo file.
set viminfo+=%          " %: saves and restores the buffer list
set viminfo+=r/tmp      " Removable media; no marks will be stored.
set viminfo+=r/run      " ...can be given several times for multiple paths.
set viminfo+=r/mount
"
" set vi+=n~/.viminfo   " Name of viminfo file.  Use 'viminfofile' instead.
" set viminfo+=f        " limits file marks to be stored ('0 to '9, 'A to 'Z)
" set viminfo+=c        " convert encoding of viminfo... Just use utf-8. always!
"
" set viminfo+=!        " restore ALL_CAPS global variables.
                        " I used to like this, but it can create confusing debug
                        " issues—viminfo will overwrite globals set by vimrc!
"
" /: max lines of history for search patterns.  defaults to 'history'
" :: max lines of history for command-line.     defaults to 'history'
" @: max lines of history for input-line.       defaults to 'history'
set history=2500        " 10x more than $VIMRUNTIME/defaults.vim

set undofile            " automatically save and restore undo history

" project-specific state and configuration
set exrc   " allow loading project specific .vimrc, but securely!
set secure " ":autocmd", shell and write commands are not allowed in ".vimrc" in
           " the current directory and map commands are displayed.

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}1
" vim: wrap fdm=marker
