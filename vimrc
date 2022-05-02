" Nicholas A. Evans's vimrc
"
" I've been using some parts of this config since 1997... there may be better
" ways to configure vim in 2022. ;)
"
" Nota Bene: This vimrc requires at least vim 8.2.  But I'll probably keep it at
"            least *partially* working with the latest released versions in
"             * Ubuntu 22.04 LTS => v8.2.3995 as of 2022-05-02
"             * termux           => v8.2.4658 as of 2022-03-31
"
"            Known incompatibilities with 8.2.0000:
"              Patch 8.2.1794 => falsy coalescing operator (a ?? b)
"              Patch 8.2.4325 => wildoption+="pum"
"              Patch 8.2.4713 => WinScrolled event
"
"            But I can also use the bin/install-vim script in this repo to get
"            the absolute latest version.

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use XDG Base Directory Specification for runtimepath and packpath, etc.
" See https://github.com/vim/vim/issues/2034
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" $MYVIMRC is normally set by vim... except when VIMINIT is used.
if empty($MYVIMRC) | let $MYVIMRC = expand('<sfile>:p') | endif

" These *should* be set by the login shell (or by systemd?), but just in case:
let $XDG_CACHE_HOME  = $XDG_CONFIG_HOME ?? $HOME.."/.cache"
let $XDG_CONFIG_HOME = $XDG_CONFIG_HOME ?? $HOME.."/.config"
let $XDG_DATA_HOME   = $XDG_DATA_HOME   ?? $HOME.."/.local/share"
let $XDG_STATE_HOME  = $XDG_STATE_HOME  ?? $HOME.."/.local/state"
let $XDG_CONFIG_DIRS = $XDG_CONFIG_DIRS ?? "/etc/xdg"
let $XDG_DATA_DIRS   = $XDG_DATA_DIRS   ?? "/usr/local/share/:/usr/share/"

set packpath   ^=$XDG_CONFIG_HOME/vim,$XDG_DATA_HOME/vim
set runtimepath^=$XDG_CONFIG_HOME/vim,$XDG_DATA_HOME/vim
set packpath   +=$XDG_CONFIG_HOME/vim/after
set runtimepath+=$XDG_CONFIG_HOME/vim/after

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" source various initialization files from runtimepath
"
" n.b. :runtime! (with the <bang>) loads *all* matching files in runtimepath, in
" the order they are found.
"
" * $XDG_CONFIG_HOME/vim - analogous to /etc/vim
" * $XDG_DATA_HOME/vim   - analogous to /usr/share/vim
" * ~/.vim               - Deprecated. TODO: migrate to XDG instead.
" * $VIM/vimfiles        - For OS packager (e.g. debian) customizations
" * $VIMRUNTIME          - All of the default scripts that come with vim.
"
" And then the 'after' directory for each of those, but in reverse.
"
" So, my public dotfiles will mostly be in XDG_DATA_HOME/vim (or ~/.vim).
" And my private dotfiles should all be in XDG_CONFIG_HOME/vim.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

runtime! options.vim        " settings for vim options
runtime! term_options.vim   " termguicolors, &t_*, width-based opts, mouse, etc
runtime! colorscheme.vim    " themes, highlights, etc
runtime! plugins.vim        " packadd and plugin config vars.
runtime! abbreviations.vim  " may include snippets, digraphs, spelling fixes
runtime! maps_and_cmds.vim  " all my maps, autocmds, and ex commands

" n.b. plugins.vim is for selecting which plugins to load and configuring them.
" No mappings or autocmds or ex commands should be in plugins.vim.  Those belong
" in maps_and_cmds.vim instead.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
