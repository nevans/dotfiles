"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Custom mappings
"
" n.b. different plugins have various approaches to mappings:
"
"   * never creates maps, but documents some suggested maps
"   * enables  maps by setting a global var or calling a function
"   * disables maps by setting a global var or calling a function
"   * creates maps only if they don't already exist, using "mapcheck()"
"   * creates maps only if they don't already exist, using "<unique>"
"   * creates maps only if they don't already exist, using "hasmapto()"
"   * always creates its own maps, possibly clobbering yours.
"   * or any combination of the above
"
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" maps NVSOICLT => Category or description       notable prefixes     {{{1
"
"  See also ":help map-table", "map-listing", "mapping"
"  ┏━┯━━━━━━━┯━━━━━━━━┯━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┯━━━━━━━━━━━━━━━━━━━━━┓
"  ┃ │ ?map? │NVSOICLT│ Modes                         │ help                ┃
"  ┠─┼───────┼────────┼───────────────────────────────┼─────────────────────┨
"  ┃ │  map  │NVSO    │ normal visual select operator │                     ┃
"  ┃n│ nmap  │N       │ normal                        │                     ┃
"  ┃v│ vmap  │ VS     │        visual select          │                     ┃
"  ┃s│ smap  │  S     │               select          │ select-mode-mapping ┃
"  ┃x│ xmap  │ V      │        visual                 │                     ┃
"  ┃o│ omap  │   O    │                      operator │ omap-info           ┃
"  ┠─┼───────┼────────┼───────────────────────────────┼─────────────────────┨
"  ┃!│  map! │    IC  │ insert    command             │                     ┃
"  ┃i│ imap  │    I   │ insert                        │                     ┃
"  ┃c│ cmap  │     C  │           command             │                     ┃
"  ┃l│ lmap  │    ??L │ iminsert? iminsert? lang-arg  │ language-mapping    ┃
"  ┠─┼───────┼────────┼───────────────────────────────┼─────────────────────┨
"  ┃t│ tmap  │       T│ terminal                      │ terminal-typing     ┃
"  ┗━┷━━━━━━━┷━━━━━━━━┷━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━┷━━━━━━━━━━━━━━━━━━━━━┛
"
" TODO: document some of the more significant mappings from plugins
" TODO: document some of the more significant built-in mappings; ":help index"
"
" }}}1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" maps NVSO     => UI                               <F#> <Leader>     {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" because I often accidentally hit F1, and I know how to use :help
noremap           <F1>   <Esc>
noremap!          <F1>   <Esc>

" quickly turn off search highlighting
nnoremap <leader><cr> :nohl<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" maps N        => colors, highlighting...                   $ g?     {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" copied from https://stackoverflow.com/questions/9464844/how-to-get-group-name-of-highlighting-under-cursor-in-vim
function! SynStack ()
  for i1 in synstack(line("."), col("."))
    let i2 = synIDtrans(i1)
    let n1 = synIDattr(i1, "name")
    let n2 = synIDattr(i2, "name")
    echo n1 "->" n2
  endfor
endfunction

" this will help remove syntax highlighting errors that result from not having
" enough context cached... but it might be slow
nnoremap <leader>$$   :syntax sync fromstart<cr>
nnoremap <leader>$256 :set t_Co=256<cr>
nnoremap <leader>$16  :set t_Co=16<cr>
"autocmd BufEnter * :syntax sync fromstart

" occasionally I might want to toggle syntax highlighting...
" mneumonic:$yntax Yes
nnoremap <leader>$y :syntax on<cr>
" mneumonic:$yntax No
nnoremap <leader>$n :syntax off<cr>

" replaces g?{motion} => rot13
nnoremap g? :call SynStack()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" identify syntax highlighting group at the cursor (VimTip 99)
nnoremap <leader>hlid :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" maps NVSOIC   => navigation inside buffers           ^A h j k l     {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Emacs style mappings
inoremap <C-A> <C-O>^
cnoremap <C-A> <Home>

" move over *screen* lines, not actual lines. helpful for folds and wrapping
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" maps N        => arrow keys                            <Arrows>     {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" use arrow keys for quick buffers/clist navigation
" I go back and forth on whether I love this or hate it.
" It only seems to be an issue when plugins expect working arrow keys.
"
" Oh, and its a real pain when using a phone keyboard, eg TERMUX.
if $TERMUX_VERSION !~ '\d'
  nnoremap <left>  :bp<cr>
  nnoremap <right> :bn<cr>
  nnoremap <up>    :cp<cr>
  nnoremap <down>  :cn<cr>
endif

" use vim-win for quick window movement: <leader>w then arrow keys or numbers
" use tmux-navigator for quick window movement: <C-h><C-j><C-k><C-l>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" maps N        => window and tab navigation          gb <Leader>     {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" quickly open command line with...
" split window (horizontally)
nnoremap <leader>sh :split ~/
nnoremap <leader>sc :split ./
nnoremap <leader>sj :stj<space>
nnoremap <leader>sb :buffers<cr>:sbuffer<space>
" split window vertically
nnoremap <leader>vh :vsplit ~/
nnoremap <leader>vc :vsplit ./
nnoremap <leader>vj :vert stj<space>
nnoremap <leader>vb :buffers<cr>:vert sbuffer<space>
" create new tab
nnoremap <leader>th :tabnew ~/
nnoremap <leader>tc :tabnew ./
nnoremap <leader>tj :tab stj<space>
nnoremap <leader>tb :buffers<cr>:tab sbuffer<space>
" and quick tab links to important files...
nnoremap <leader>tV :tabnew ~/.vimrc<cr>
nnoremap <leader>tB :tabnew ~/.bashrc<cr>
nnoremap <leader>tT :tabnew ~/Documents/TODO<cr>
nnoremap <leader>tJ :tabnew ~/Documents/work/journal.md<cr>
" in current window
nnoremap <leader>eh :e ~/
nnoremap <leader>ec :e ./
nnoremap <leader>ej :tj<space>
nnoremap <leader>eb :buffers<cr>:buffer<space>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" maps  VS      => visual mode                                    etc {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable TAB indent and SHIFT-TAB unindent
"inoremap <S-TAB> <C-O><<
vnoremap <silent> <TAB>   >gv
vnoremap <silent> <S-TAB> <gv

" quick search for visual selection
vnoremap / y/<C-R>"<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" maps      C   => Command mode                                   etc {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" quick dirname in command mode
cnoremap %% <c-r>=expand('%:h').'/'<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" maps NVSOIC   => mouse                                  <Mouse>     {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Scroll only one line for mouse wheel events to get smooth scrolling on touch screens
if $TERMUX_VERSION =~ '\d'
  map  <ScrollWheelUp>   <C-Y>
  imap <ScrollWheelUp>   <C-X><C-Y>
  map  <ScrollWheelDown> <C-E>
  imap <ScrollWheelDown> <C-X><C-E>
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" maps NVSO     => vim-which-key           <LocalLeader> <Leader>     {{{1
" TODO: plugin is optional; only apply these when the plugin has been loaded
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-which-key plugin: provides dynamically generated menu from mappings
if !empty(get(g:vimrc_packs, "vim-which-key"))
  nnoremap <silent> <leader>      :<c-u>WhichKey       '<Space>'<CR>
  vnoremap <silent> <leader>      :<c-u>WhichKeyVisual '<Space>'<CR>
  nnoremap <silent> <localleader> :<c-u>WhichKey       ','<CR>
  vnoremap <silent> <localleader> :<c-u>WhichKeyVisual ','<CR>
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" maps NV OI    => fzf and fzf.vim                 ^x ^p <Leader> etc {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" n.b. <c-p> in insert should remain the default.
" I only chose this to match VSCode, but probable another mapping is better.
nmap <c-p> :GitFiles<CR>
" These mappings are taken from :help fzf-vim

" Mapping selecting mappings.  See "fzf-vim-mappings"
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)
" imap <leader><tab> <plug>(fzf-maps-i)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-l> <plug>(fzf-complete-line)
" Path completion with custom source command
"
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('fd')
inoremap <expr> <c-x><c-f> fzf#vim#complete#path('rg --files')

" Word completion with custom spec with popup layout option
inoremap <expr> <c-x><c-k> fzf#vim#complete#word({'window': { 'width': 0.2, 'height': 0.9, 'xoffset': 1 }})

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" maps N        => NERDTree                            <Leader>d      {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" open/close file browser
nmap <leader>d :NERDTreeToggle<CR>
" open file browser rooted in current file's dir
nmap <leader>D :NERDTree %<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" maps N        => vim-test                            <Leader>tt     {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <silent> <unique> <Leader>ttn   :TestNearest<CR>
nmap <silent> <unique> <Leader>ttf   :TestFile<CR>
nmap <silent> <unique> <Leader>tts   :TestSuite<CR>
nmap <silent> <unique> <Leader>ttl   :TestLast<CR>
nmap <silent> <unique> <Leader>ttg   :TestVisit<CR>
nmap <silent> <unique> <Leader>ttt   :TestFile<CR>
nmap <silent> <unique> <Leader>t<CR> :TestFile<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" maps NVSOI    => coc.nvim                  ][ g <Ctrl> <Leader> etc {{{1
" TODO: plugin is optional; only apply these when the plugin has been loaded
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if !exists("g:vimrc_enable_coc_maps")
  let g:vimrc_enable_coc_maps =
        \ !empty(get(g:vimrc_packs, "coc.nvim"))
        \ || get(g:vimrc_packs, "lsp_client", "") == "coc.nvim"
        \ || get(g:vimrc_packs, "completion", "") == "coc.nvim"
endif

if g:vimrc_enable_coc_maps

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" ^^^ this was broken before... fixed by updating either vim or coc.nvim or both

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
" TODO: this clobbers some other plugins documentation. :(
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OganizaeImports   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <leader>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <leader>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <leader>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <leader>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <leader>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <leader>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <leader>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <leader>p  :<C-u>CocListResume<CR>

endif
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim modeline... {{{1
" vim: wrap fdm=marker
