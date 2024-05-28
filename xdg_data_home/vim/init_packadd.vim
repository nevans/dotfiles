" default plugins... (packadd, etc)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" configure this in $XDG_CONFIG_HOME/vim/init_packadd.vim
let g:vimrc_packs = get(g:, 'vimrc_packs', {})

" automatically set a bunch of vimrc_packs at once
if empty($VIM_LSP)
  if g:vimrc_packs->has_key('lsp')
    let $VIM_LSP = g:vimrc_packs['lsp']
  else
    let $VIM_LSP = 'ale'
  endif
endif " lightweight default

if $VIM_LSP ==? 'ale'
  let g:vimrc_packs['ale']        = { "disable_lsp": v:false }
  let g:vimrc_packs['completion'] = 'supertab'
  let g:vimrc_packs['lsp_client'] = 'ale'
elseif $VIM_LSP ==? 'coc' || $VIM_LSP ==? 'coc.nvim'
  " let g:vimrc_packs['ale']        = { "disable_lsp": v:true }
  let g:vimrc_packs['completion'] = 'coc.nvim'
  let g:vimrc_packs['lsp_client'] = 'coc.nvim'
elseif $VIM_LSP ==? 'lsp'
  let g:vimrc_packs['lsp_client']          = 'lsp'
  let g:vimrc_packs['lsp_client-settings'] = 'lsp-settings'
  let g:vimrc_packs['completion']          = 'asyncomplete.vim'
  let g:vimrc_packs['completion-buffer']   = 'asyncomplete-buffer.vim'
  let g:vimrc_packs['completion-emoji']    = 'asyncomplete-emoji.vim'
  let g:vimrc_packs['completion-file']     = 'asyncomplete-file.vim'
  let g:vimrc_packs['completion-lsp']      = 'asyncomplete-lsp.vim'
  let g:vimrc_packs['completion-tags']     = 'asyncomplete-tags.vim'
else
  " no-op, none configured.  Config in $XDG_CONFIG_HOME/vim/init_packadd.vim
  echom 'No $VIM_LSP configured'
  " TODO... add other LSP/completion/linter combos
  " TODO... load appropriate maps, autocmds, etc for the LSP/completion combo
endif

" I deleted or commented out my old statusline.  I don't love airline, but
" things don't look right unless I'm using airline... for now.
if !g:vimrc_packs->has_key('statusline')
  let g:vimrc_packs['statusline']        = 'vim-airline'
  let g:vimrc_packs['statusline-themes'] = 'vim-airline-themes'
endif

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
