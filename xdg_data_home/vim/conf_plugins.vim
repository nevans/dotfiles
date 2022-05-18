"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugins: paths, config vars, etc.
"
" Config vars should generally be set unconditionally, even for unloaded
" optional plugins.  The primary reason for dynamically setting variables is
" handling conflicts between different similar plugins. e.g. which plugins
" handle completion, or LSP, fuzzy lookups, snippets, etc.  Settings may also
" change based on whether or not executables are available, what version of
" something is available, or other environmental factors.
"
" Use ./init_packadd.vim to select which plugins will be loaded.
" Use ./conf_maps_cmds.vim for plugin maps, ex commands, autocommands, etc.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Plugin paths (follow XDG Base Directory Specification)                 {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: netrw                                            {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:netrw_home      =  $XDG_DATA_HOME..'/vim'
let g:netrw_liststyle = 3 " tree style

" Plugin: unicode.vim                                      {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:Unicode_data_directory  = $XDG_DATA_HOME  ..'/vim'
let g:Unicode_cache_directory = $XDG_CACHE_HOME ..'/vim'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}1
" Plugin configurations                                                  {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: airline                                          {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" let g:airline_experimental = 1  " enable new vim9 implementation

let g:airline#extensions#tabline#show_buffers            = 1
let g:airline#extensions#tabline#buf_label_first         = 1
let g:airline#extensions#tabline#buffers_label           = 'bufs'
let g:airline#extensions#tabline#enabled                 = 1
let g:airline#extensions#tabline#show_tab_nr             = 1
let g:airline#extensions#tabline#show_tab_type           = 1
let g:airline#extensions#tabline#switch_buffers_and_tabs = 1
let g:airline#extensions#tabline#tab_nr_type             = 2 " splits and tab number
let g:airline#parts#ffenc#skip_expected_string           = 'utf-8[unix]'

let g:airline_exclude_preview                            = 0
let g:airline_powerline_fonts                            = 1
let g:airline_section_c_only_filename                    = 0
let g:airline_skip_empty_sections                        = 1
let g:airline_symbols_ascii                              = 0

" NB: no*, cv, ce, r? and ! do not actually display
"  I added extra space where either vim or my terminal were ignorant of double
"  wide characters.
let g:airline_mode_map = {
      \ '__':    '----',
      \ 'n':     'N✅',  'c':   'C:…',
      \ 'i':     'I📝',  'ic':  'I🎱',  'ix':  'I🔮',
      \ 'R':     'R📝',  'Rc':  'R🎱',  'Rx':  'R🔮',
      \ 's':     'S……',  'S':   'S☰☰',  '':  'S▒▒',
      \ 'v':     'V……',  'V':   'V☰☰',  '':  'V▒▒',
      \ 't':     'T💻',  'nt':  'N💻',
      \ 'multi': 'M🎛️',
      \ 'Rv':    'Rv📝', 'Rvc': 'Rv🎱', 'Rvx': 'Rv🔮',
      \ 'niI':   'N<<I', 'niR': 'N<<R', 'niV': 'N<<V',
      \ 'vs':    'V…<S', 'Vs':  'V☰<S', 's': 'V▒<S',
      \ }

" my symbols
" copied and pasted from :help airline-customization
let g:airline_symbols = get(g:, 'airline_symbols', {})

" shrink to single char, removing superfluous whitespace and ':'
let g:airline_symbols.linenr    = ''
let g:airline_symbols.colnr     = ''
let g:airline_symbols.maxlinenr = '☰'

" emoji > powerline or other nerd font symbols
" n.b. vim-emoji-icon-theme plugin sets many of these too...
let g:airline_symbols.spell    = '📖'   " see, it's a dictionary...
let g:airline_symbols.paste    = '📋'   " from the clipboard
let g:airline_symbols.readonly = '🔒✍️' " locked from writing
let g:airline_symbols.crypt    = '🔓🔑' " unlocked with keyboard

let g:airline#extensions#branch#format   = 1 " feature/foo -> foo
let g:airline#extensions#branch#sha1_len = 6

" TODO: fix unreadably low contrast of inactive splits
" TODO: fix skinny width components
" TODO: slimmer linenr, maxlinenr, colnr

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: ale                                              {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" n.b. filetype-specific settings have mostly been moved to the appropriate
" ftplugin directory.

" Use ALE for LSP, unless another LSP is configured (coc.nvim, vim-lsp, ?)
let g:ale_disable_lsp = 'ale' != get(g:vimrc_packs, 'lsp_client', 'ale')

if !exists('g:ale_linters')         | let g:ale_linters = {}         | endif
if !exists('g:ale_linters_ignore')  | let g:ale_linters_ignore = {}  | endif
if !exists('g:ale_fixers')          | let g:ale_fixers = {}          | endif
if !exists('g:ale_pattern_options') | let g:ale_pattern_options = {} | endif

let g:ale_fixers["c"]   = ["remove_trailing_lines", "trim_whitespace", "clang-format"]
let g:ale_fixers["cpp"] = ["remove_trailing_lines", "trim_whitespace", "clang-format"]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ALE: ruby config                                     {{{3
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
      \ 'reek',
      \]

" let g:ale_linters["ruby"] = ['sorbet']
" let g:ale_linters["ruby"] += ['rails_best_practices']

" let g:ale_fixers["ruby"] += ["remove_trailing_lines", "trim_whitespace"]
" let g:ale_fixers["ruby"] += ["rubocop"]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ALE: javascript config                                     {{{3
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:ale_linters_ignore["javascript"] = [
      \ 'standard',
      \ 'prettier',
      \]
let g:ale_linters_ignore["typescript"] = g:ale_linters_ignore['javascript']

let g:ale_linters_ignore["javascriptreact"] = g:ale_linters_ignore['javascript']
let g:ale_linters_ignore["typescriptreact"] = g:ale_linters_ignore['typescript']

" }}}3

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: coc.nvim                                         {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:coc_config_home = $XDG_CONFIG_HOME..'/vim'

let g:coc_global_extensions = [
      \ '@yaegassy/coc-ansible',
      \ 'coc-clangd',
      \ 'coc-clang-format-style-options',
      \ 'coc-css',
      \ 'coc-diagnostic',
      \ 'coc-emoji',
      \ 'coc-eslint',
      \ 'coc-fzf-preview',
      \ 'coc-go',
      \ 'coc-gocode',
      \ 'coc-html',
      \ 'coc-json',
      \ 'coc-lists',
      \ 'coc-solargraph',
      \ 'coc-tsserver',
      \ 'coc-vimlsp',
      \ 'coc-yaml',
      \ ]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: fzf and fzf.vim                                  {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" use vim 8.2 popup windows! (yay!)
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6 } }

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: ack.vim                                          {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ackprg='ag --nogroup --nocolor --column'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: netrw                                            {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:netrw_liststyle=3 " tree style

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: bufexplorer                                      {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:bufExplorerShowRelativePath=1  " Show relative paths.
let g:bufExplorerSortBy='mru'        " Sort by MRU (cycle other sorts: s or S)
let g:bufExplorerSplitOutPathName=1  " Split the path and file name.
let g:bufExplorerSplitVertSize=0     " New split window cols (0 is set by Vim)
let g:bufExplorerSplitHorzSize=0     " New split window rows (0 is set by Vim)
let g:bufExplorerSplitRight=0        " Split left.
let g:bufExplorerFindActive=0        " Do not go to active window. (toggle: a)

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: vimwiki                                          {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let g:vimwiki_hl_cb_checked = 1
let g:vimwiki_global_ext = 0
let wiki = {}
let wiki.path            = '~/Documents/vimwiki/'
let wiki.diary_rel_path  = './'
let wiki.diary_index     = 'DailyJournal'
let wiki.diary_header    = 'Daily Journal'
let wiki.diary_header    = 'Daily Journal'
let wiki.nested_syntaxes = {'ruby': 'ruby', 'python': 'python', 'html': 'html'}
let g:vimwiki_list     = [wiki]
let g:vimwiki_dir_link = 'index'

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin: vim-test                                        {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let test#vim#term_height = '20'

if has('terminal')
  let test#strategy = "vimterminal"
else
  let test#strategy = "dispatch"
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}1
" FT plugin configs (TODO: move to ftplugins)                            {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ftplugin: ruby-vim                                       {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ruby_indent_assignment_style = 'variable'
let ruby_fold                      = 1
let ruby_foldable_groups           = 'module class def do __END__'
let ruby_minlines                  = 250
let ruby_operators                 = 1
let ruby_pseudo_operators          = 1
let ruby_space_errors              = 1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ftplugin: markdown                                       {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" syntax highlighting in code blocks:
let g:markdown_fenced_languages = ['ruby', 'html', 'bash=sh']
let g:markdown_folding_level = 6

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ftplugin: vim-json                                       {{{2
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:vim_json_syntax_conceal = 0

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""" }}}1
" vim modeline... {{{1
" vim: wrap fdm=marker
