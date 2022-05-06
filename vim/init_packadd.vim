" default plugins... (packadd, etc)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" configure this in $XDG_CONFIG_HOME/vim/init_packadd.vim
let g:vimrc_packs = get(g:, 'vimrc_packs', {})

" runs packadd for every pack in vimrc_packs
"
" TODO: should g:vimrc_packs be a List instead of a Dict, to retain order?
function! VimrcAddPacks() abort
  if !len(g:vimrc_packs) | return | endif

  for [name, opts] in items(g:vimrc_packs)
    if !empty(opts)
      call s:add_one_pack(name, opts)
    else
      " falsy opts print a disabled warning
      redraw | echom "Pack disabled: "..name..".  To avoid this message, "
            \ .."call remove(g:vimrc_paths, '"..name.."')"
    endif
  endfor

  " n.b. ':filetype plugin indent on' needs to run (again) after ':packadd!'
  filetype plugin indent on
endfunction

function! s:add_one_pack(name, opts) abort
  if type(a:opts) == type("")
    exe "packadd!" a:opts
  elseif type(a:opts) == type({}) && get(a:opts, "name")
    exe "packadd!" a:opts["name"]
  elseif type(a:opts) == type({}) && get(a:opts, "pack")
    exe "packadd!" a:opts["pack"]
  else
    " everything else is considered truthy, without overriding "name"
    exe "packadd!" a:name
  endif
endfunction

call VimrcAddPacks()
