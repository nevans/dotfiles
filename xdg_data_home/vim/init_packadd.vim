" default plugins... (packadd, etc)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" configure this in $XDG_CONFIG_HOME/vim/init_packadd.vim
let g:vimrc_packs = get(g:, 'vimrc_packs', #{})

function! s:assign_defaults() abort
  if g:vimrc_packs.get("defaults", v:true)
    call g:vimrc_packs->remove("defaults")
  endif
endfunction

" runs packadd for every pack in vimrc_packs
"
" TODO: should g:vimrc_packs be a List instead of a Dict, to retain order?
function! VimrcAddPacks() abort
  if !len(g:vimrc_packs) | return | endif

  for [name, opts] in items(g:vimrc_packs)
    call s:add_one_pack(name, opts)
  endfor

  " n.b. ':filetype plugin indent on' needs to run (again) after ':packadd!'
  filetype plugin indent on
endfunction

function! s:add_one_pack(name, opts) abort
  if a:opts is v:false || a:opts is v:null || a:opts is v:none
    " ignore explicitly falsy values
  elseif empty(a:opts)
      " other falsy opts print a disabled warning
      redraw | echom "Pack disabled: "..name..".  To avoid this message, "
            \ ..":let g:vimrc_paths["..name.."] = v:false   or   "
            \ .."call remove(g:vimrc_paths, '"..name.."')"
  elseif type(a:opts) == type("")
    exe "packadd!" a:opts
  elseif type(a:opts) == type({}) && get(a:opts, "name")
    exe "packadd!" a:opts["name"]
  elseif type(a:opts) == type({}) && get(a:opts, "pack")
    exe "packadd!" a:opts["pack"]
  elseif type(a:opts) == type([])
    for packname in a:opts
      exe "packadd!" packname
    endfor
  else
    " everything else is considered truthy, without overriding "name"
    exe "packadd!" a:name
  endif
endfunction

call VimrcAddPacks()
