""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use XDG Base Directory Specification for runtimepath and packpath, etc.
"
" * $XDG_CONFIG_HOME - user config, analogous to /etc/vim
" * ~/.vim           - Deprecated. TODO: migrate to XDG instead.
" * $XDG_DATA_HOME   - user default setup, analogous to /usr/share/vim
" * TODO: $XDG_CONFIG_DIRS - machine, OS, default configs. /etc, /etc/xdg, etc
" * TODO: $XDG_DATA_DIRS   - machine, OS, default data. /usr/share, snaps, etc
" * $VIM/vimfiles    - OS (e.g. debian) or packager (e.g.brew) config/data
" * $VIMRUNTIME      - All of the default scripts that come with vim.
"
" And then the 'after' directory for each of those, but in reverse.
"
" n.b. :runtime! (with the <bang>) loads *all* matching files in runtimepath, in
" the order they are found.
"
" So, my public dotfiles will mostly be in $XDG_DATA_HOME/vim (or ~/.vim).
" And my private dotfiles should all be in XDG_CONFIG_HOME/vim.
"
" TODO: Maybe I should add $XDG_CONFIG_DIRS and $XDG_DATA_DIRS, if they exist.
"       I'll want to make sure that plays nicely with Debian, Ubuntu, termux,
"       and whatever locally compiled version I'm running (etc).
"
" See also:
"  * https://github.com/vim/vim/issues/2034
"  * https://wiki.debian.org/XDGBaseDirectorySpecification
"  * https://wiki.archlinux.org/title/XDG_Base_Directory
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" These *should* be set by the login shell (or by systemd?), but just in case...
if has("patch-8.2.1794")
  " this syntactic sugar is trivial and unimportant... but I like it better!
  let $XDG_CACHE_HOME  = $XDG_CACHE_HOME  ?? $HOME.."/.cache"
  let $XDG_CONFIG_HOME = $XDG_CONFIG_HOME ?? $HOME.."/.config"
  let $XDG_DATA_HOME   = $XDG_DATA_HOME   ?? $HOME.."/.local/share"
  let $XDG_STATE_HOME  = $XDG_STATE_HOME  ?? $HOME.."/.local/state"
  let $XDG_CONFIG_DIRS = $XDG_CONFIG_DIRS ?? "/etc/xdg"
  let $XDG_DATA_DIRS   = $XDG_DATA_DIRS   ?? "/usr/local/share/:/usr/share/"
endif

" remove and then re-add my personal runtimepath config and data files so they
" come before (and after) all other default runtimepaths.
function! g:XDG_init_rtp() abort
  let my_rtp = [
        \ $XDG_CONFIG_HOME.."/vim",
        \ $HOME.."/.vim",
        \ $XDG_DATA_HOME.."/vim",
      \ ]->join(",")
  " remove from rtp and pp (is all of this really neccessary?
  " why wasn't "exe 'set rtp-=foo'" working?
  for option in ["runtimepath", "packpath"]
    for dir in my_rtp->split(",")
      let paths = eval("&"..option)->split(",")
      call filter(paths, {i, p -> (simplify(p) != simplify(dir))})
      call filter(paths, {i, p -> (simplify(p) != simplify(dir.."/after"))})
      exe "set "..option.."="..join(paths, ",")
    endfor
  endfor
  " add back to rtp and pp
  for option in ["runtimepath", "packpath"]
    for dir in my_rtp->split(",")->reverse()
      exe "set "..option.."^="..simplify(dir)
      exe "set "..option.."+="..simplify(dir.."/after")
    endfor
  endfor
endfunction

function! g:XDG_mkdirs()
  call mkdir($XDG_CACHE_HOME,  'p', 0700)
  call mkdir($XDG_CONFIG_HOME, 'p', 0700)
  call mkdir($XDG_DATA_HOME,   'p', 0700)
  call mkdir($XDG_STATE_HOME,  'p', 0700)
endfunction

" I thought views and backups might belong in $XDG_DATA_HOME.  But both Debian
" and Arch think they belong in $XDG_STATE_HOME.  I'll follow their lead.
"  * https://wiki.debian.org/XDGBaseDirectorySpecification
"  * https://wiki.archlinux.org/title/XDG_Base_Directory
"
" From the XDG spec:
"   The $XDG_STATE_HOME contains state data that should persist between
"   (application) restarts, but that is not important or portable enough to the
"   user that it should be stored in $XDG_DATA_HOME. It may contain:
"     * actions history (logs, history, recently used files, …)
"     * current state of the application that can be reused on a restart
"       (view, layout, open files, undo history, …)
"
" From :help 'directory' (also applies to 'backupdir' and 'undodir')
"       For Unix and Win32, if a directory ends in two path separators "//",
"       the swap file name will be built from the complete path to the file
"       with all path separators replaced by percent '%' signs (including
"       the colon following the drive letter on Win32). This will ensure
"       file name uniqueness in the preserve directory.
function! g:XDG_config_state_dirs() abort
  let &viminfofile=$XDG_STATE_HOME.."/vim/viminfo"
  let &directory  =$XDG_STATE_HOME.."/vim/swap//"  |call mkdir(&directory,'p',0700)
  let &undodir    =$XDG_STATE_HOME.."/vim/undo//"  |call mkdir(&undodir,  'p',0700)
  let &backupdir  =$XDG_STATE_HOME.."/vim/backup//"|call mkdir(&backupdir,'p',0700)
  let &viewdir    =$XDG_STATE_HOME.."/vim/view"    |call mkdir(&viewdir,  'p',0700)
endfunction

function! g:XDG_init() abort
  call XDG_init_rtp()
  call XDG_mkdirs()
  call XDG_config_state_dirs()
endfunction

call XDG_init()

" this isn't important. but I'm annoyed by plugins jumping in front of my config
augroup XDG_init_autocmds
  au!
  au VimEnter * ++once call XDG_init_rtp()
augroup END
