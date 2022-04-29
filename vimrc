" Nicholas A. Evans's vimrc
"
" I've been using some parts of this config since 1997... there may be better
" ways to configure vim in 2022? ;)
"
" Nota Bene: This vimrc probably requires at least vim 8.2.
"            It probably isn't 100% compatible with neovim, either.

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use XDG Base Directory Specification for runtimepath and packpath.
" All other XDG paths are configured in options.vim.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" $MYVIMRC is normally set by vim... except when VIMINIT is used.
if empty($MYVIMRC) | let $MYVIMRC = expand('<sfile>:p') | endif

" these *should* be set by the shell initialization, but just in case:
if empty($XDG_CACHE_HOME)  | let $XDG_CACHE_HOME =$HOME..'/.cache'       | endif
if empty($XDG_CONFIG_HOME) | let $XDG_CONFIG_HOME=$HOME..'/.config'      | endif
if empty($XDG_DATA_HOME)   | let $XDG_DATA_HOME  =$HOME..'/.local/share' | endif
if empty($XDG_STATE_HOME)  | let $XDG_STATE_HOME =$HOME..'/.local/state' | endif

" The following system paths are already set, from lowest to highest priority:
"  * $VIMRUNTIME         — probably $VIM/vim{version} e.g. /usr/share/vim/vim82
"  * $VIM/vimfiles       — e.g. /usr/share/vim/vimfiles.
"  * $HOME/.vim          — TODO: migrate to XDG dirs and deprecate $HOME/.vim
"
" Others may set as well. E.g. Debian adds /etc/vim and /var/lib/vim/addons.

" TODO: set runtimepath-=$HOME/.vim
" TODO: set packpath   -=$HOME/.vim
" TODO: set runtimepath-=$HOME/.vim/after
" TODO: set packpath   -=$HOME/.vim/after

" My own default baseline vim runtime environment.  Analogous to $VIM/vimfiles.
set runtimepath^=$XDG_DATA_HOME/vim
set packpath   ^=$XDG_DATA_HOME/vim
set runtimepath+=$XDG_DATA_HOME/vim/after
set packpath   +=$XDG_DATA_HOME/vim/after

" User runtime environment that is private or specific to this env.  This has
" priority over all of the rest, running both before and after all others.
set runtimepath^=$XDG_CONFIG_HOME/vim
set packpath   ^=$XDG_CONFIG_HOME/vim
set runtimepath+=$XDG_CONFIG_HOME/vim/after
set packpath   +=$XDG_CONFIG_HOME/vim/after

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" with a <bang>, runtime! will source *all* matches on &runtimepath
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

runtime! options.vim        " settings for vim options
runtime! term_options.vim   " termguicolors, &t_*, width-based opts, mouse, etc
runtime! colorscheme.vim    " themes, highlights, etc
runtime! abbreviations.vim  " may include snippets, digraphs, spelling fixes
runtime! plugins.vim        " packadd and configuration, *except* for maps
runtime! mappings.vim       " all of my custom mappings, including for plugins

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
