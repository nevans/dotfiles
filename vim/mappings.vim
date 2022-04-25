" Custom mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings: UI                                                 (nmap)    {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" because I often accidentally hit F1, and I know how to use :help
noremap           <F1>   <Esc>
noremap!          <F1>   <Esc>

" quickly turn off search highlighting
noremap <leader><cr> :nohl<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings: colors and syntax highlighting...                  (nmap)    {{{1
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
noremap <leader>$$   :syntax sync fromstart<cr>
noremap <leader>$256 :set t_Co=256<cr>
noremap <leader>$16  :set t_Co=16<cr>
"autocmd BufEnter * :syntax sync fromstart

" occasionally I might want to toggle syntax highlighting...
" mneumonic:$yntax Yes
noremap <leader>$y :syntax on<cr>
" mneumonic:$yntax No
noremap <leader>$n :syntax off<cr>

" replaces g?{motion} => rot13
nnoremap g? :call SynStack()<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" identify syntax highlighting group at the cursor (VimTip 99)
nnoremap <leader>hlid :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings: navigation inside buffers                          (nmap)    {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Emacs style mappings
inoremap <C-A> <C-O>^
cnoremap <C-A> <Home>

" when wrap is on, only navigate over *screen* lines, not actual lines
nnoremap j gj
nnoremap k gk
vnoremap j gj
vnoremap k gk

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings: navigation between files and buffers               (nmap)    {{{1
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
" mappings: window and tab navigation                          (nmap)    {{{1
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
" mappings: visual mode                                        (vmap)    {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Enable TAB indent and SHIFT-TAB unindent
"inoremap <S-TAB> <C-O><<
vnoremap <silent> <TAB>   >gv
vnoremap <silent> <S-TAB> <gv

" quick search for visual selection
vnoremap / y/<C-R>"<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings: command mode                                       (cmap)    {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" quick dirname in command mode
cnoremap %% <c-r>=expand('%:h').'/'<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings: mouse                                          {map,imap)    {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

  " Scroll only one line for mouse wheel events to get smooth scrolling on touch screens
  map  <ScrollWheelUp>   <C-Y>
  imap <ScrollWheelUp>   <C-X><C-Y>
  map  <ScrollWheelDown> <C-E>
  imap <ScrollWheelDown> <C-X><C-E>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings: vim-which-key                                                {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" vim-which-key plugin: provides dynamically generated menu from mappings
" TODO: plugin is optional; only apply these when the plugin has been loaded
" nnoremap <silent> <leader>      :<c-u>WhichKey       '<Space>'<CR>
" vnoremap <silent> <leader>      :<c-u>WhichKeyVisual '<Space>'<CR>
" nnoremap <silent> <localleader> :<c-u>WhichKey       ','<CR>
" vnoremap <silent> <localleader> :<c-u>WhichKeyVisual ','<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mappings: fzf and fzf.vim                                              {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

nmap <c-p> :GitFiles<CR>
" These mappings are taken from :help fzf-vim

" Mapping selecting mappings
nmap <leader><tab> <plug>(fzf-maps-n)
xmap <leader><tab> <plug>(fzf-maps-x)
omap <leader><tab> <plug>(fzf-maps-o)

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
" mappings: NERDTree                                           (cmap)    {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" open/close file browser
nmap <leader>d :NERDTreeToggle<CR>
" open file browser rooted in current file's dir
nmap <leader>D :NERDTree %<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim modeline... {{{1
" vim: wrap fdm=marker
