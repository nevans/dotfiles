"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-ruby config                                     {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:ruby_indent_assignment_style = 'variable'
let g:ruby_fold                    = 1 " TODO: keymap to toggle ruby_fold
let g:ruby_foldable_groups         = 'def do __END__'
let g:ruby_minlines                = 250 " TODO: set this in a project specific way...
let g:ruby_operators               = 1
let g:ruby_pseudo_operators        = 1
let g:ruby_space_errors            = 1 " already handled elsewhere
let g:ruby_spellcheck_strings      = 1 " when spellchecking is enabled...
let g:ruby_no_expensive            = 1 " :(

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ALE config                                     {{{
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" by contraining ALE to use bundler, we won't run linters/fixers that aren't
" configured for the project.
let g:ale_ruby_brakeman_executable   = 'bundle'
let g:ale_ruby_reek_executable       = 'bundle'
let g:ale_ruby_rubocop_executable    = 'bundle'
let g:ale_ruby_standardrb_executable = 'bundle'

" That said, never run prettier.  It hates me; I hate it.
let g:ale_linters_ignore["ruby"] = ["prettier"]

let g:ale_linters["ruby"] = [
      \ 'ruby',
      \ 'rubocop',
      \ 'solargraph',
      \]

" let g:ale_linters["ruby"] = ['sorbet']
" let g:ale_linters["ruby"] += ['rails_best_practices']

" let g:ale_fixers["ruby"] += ["remove_trailing_lines", "trim_whitespace"]
" let g:ale_fixers["ruby"] += ["rubocop"]

" RSpec.vim mappings (move to rspec.vim?)
map <Leader>t :call RunCurrentSpecFile()<CR>
map <Leader>s :call RunNearestSpec()<CR>
map <Leader>l :call RunLastSpec()<CR>
map <Leader>a :call RunAllSpecs()<CR>

" vim-rspec should use vim-dispatch
let g:rspec_command = "Dispatch rspec {spec}"
" TODO: get spring working.
"let g:rspec_command = "Dispatch rspec {spec}"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ruby: some auto-appending of closing characters
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"autocmd User Rails   inoremap <buffer> do<space>\| do<cr>end<esc><up>A<space>\|\|<left>
"autocmd User Rails   inoremap <buffer> do<cr>      do<cr>end<esc>O
"autocmd User Rails   inoremap <buffer> ""          ""<left>
"autocmd User Rails   inoremap <buffer> ''          ''<left>
"autocmd User Rails   inoremap <buffer> ``          ``<left>
"autocmd User Rails   inoremap <buffer> ()          ()<left>
"autocmd User Rails   inoremap <buffer> {}          {}<left>
"autocmd User Rails   inoremap <buffer> []          []<left>
"autocmd User Rails   iabbr    <buffer> def@        def<cr>end<esc><up>A
"autocmd User Rails   iabbr    <buffer> class@      class<cr>end<esc><up>A

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ruby: rcodetools
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" plain annotations
map <silent> <F10> !xmpfilter -a<cr>
nmap <silent> <F10> V<F10>
imap <silent> <F10> <ESC><F10>a

" generate RSpec expectations
map <silent> <S-F10> !xmpfilter -s<cr>
nmap <silent> <S-F10> V<S-F10>
imap <silent> <S-F10> <ESC><S-F10>a

" Annotate the full buffer
" I actually prefer ggVG to %; it's a sort of poor man's visual bell
nmap <silent> <F11> mzggVG!xmpfilter -a<cr>'z
imap <silent> <F11> <ESC><F11>

" assertions
nmap <silent> <S-F11> mzggVG!xmpfilter -s<cr>'z
imap <silent> <S-F11> <ESC><S-F11>a

" Add # => markers
vmap <silent> <F12> !xmpfilter -m<cr>
nmap <silent> <F12> V<F12>
imap <silent> <F12> <ESC><F12>a

" Remove # => markers
vmap <silent> <S-F12> ms:call RemoveRubyEval()<CR>
nmap <silent> <S-F12> V<S-F12>
imap <silent> <S-F12> <ESC><S-F12>a

function! RemoveRubyEval() range
  let begv = a:firstline
  let endv = a:lastline
  normal Hmt
  set lz
  execute ":" . begv . "," . endv . 's/\s*# \(=>\|!!\).*$//e'
  normal 'tzt`s
  set nolz
  redraw
endfunction

if expand('%:p') =~# '^/home/nick/src/uri/'
  let b:ale_ruby_rubocop_executable = 'rubocop'
endif
