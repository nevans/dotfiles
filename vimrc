" Nicholas A. Evans's vimrc
"
" I've been using some parts of this config since 1997... there may be better
" ways to configure vim in 2022. ;)
"
" Nota Bene: This vimrc requires at least vim 8.0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use XDG Base Directory Specification for runtimepath and packpath
" all other XDG paths are configured in options.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" $MYVIMRC is normally set by vim... except when VIMINIT is used.
if empty($MYVIMRC) | let $MYVIMRC = expand('<sfile>:p') | endif

" these *should* be set by the shell initialization, but just in case:
if empty($XDG_CACHE_HOME)  | let $XDG_CACHE_HOME =$HOME..'/.cache'      | endif
if empty($XDG_CONFIG_HOME) | let $XDG_CONFIG_HOME=$HOME..'/.config'     | endif
if empty($XDG_DATA_HOME)   | let $XDG_DATA_HOME =$HOME..'/.local/share' | endif
if empty($XDG_STATE_HOME)  | let $XDG_STATE_HOME=$HOME..'/.local/state' | endif

set runtimepath^=$XDG_DATA_HOME/vim
set runtimepath+=$XDG_DATA_HOME/vim/after
set runtimepath^=$XDG_CONFIG_HOME/vim
set runtimepath+=$XDG_CONFIG_HOME/vim/after

set packpath^=$XDG_DATA_HOME/vim
set packpath+=$XDG_DATA_HOME/vim/after
set packpath^=$XDG_CONFIG_HOME/vim
set packpath+=$XDG_CONFIG_HOME/vim/after

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" source various initialization files from runtimepath
"
" n.b. :runtime! (with the <bang>) loads *all* matching files in runtimepath, in
" the order they are found.
"
" ~/.config/vim > ~/.local/share/vim > ~/.vim > $VIMRUNTIME > $VIMRUNTIME/after
"   > ~/.vim/after > ~/.local/share/vim/after > ~/.config/vim/after
"
" So, public dotfiles can be placed in XDG_DATA_HOME/vim or ~/.vim
"  & private dotfiles can be placed in XDG_CONFIG_HOME/vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

runtime! options.vim        " settings for vim options
runtime! term_options.vim   " termguicolors, &t_*, width-based opts, mouse, etc
runtime! colorscheme.vim    " themes, highlights, etc
runtime! abbreviations.vim  " may include snippets, digraphs, spelling fixes
runtime! plugins.vim        " packadd and configuration, *except* for maps
runtime! mappings.vim       " all of my custom mappings, including for plugins

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
