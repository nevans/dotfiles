" Terminal or window width options                                       {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

augroup vimrc_resize_options
  au!

  " This handles font-size changes, too!
  " WinScrolled seems like it should be good here, but it needs some tweaks.
  au VimResized                          * call s:auto_adjust_window_sizes()
  " even with 'equalalways' set, it seems some scenarios are unhandled.
  function s:auto_adjust_window_sizes()
    " TODO: make special windows fixed or min/max width/height
    execute "normal! \<c-w>="
  endfunction

  if has("vim9script")
    au VimEnter,VimResized,WinNew,WinEnter,WinScrolled * call AdjustWindowOptionsForWidth()

    def AdjustWindowOptionsForWidth(): void
      if exists("w:adjust_options_for_width_ignored")
        # marked to be ignored
        return
      endif

      var cols = winwidth(0)
      if exists("w:adjust_options_for_width_previous_width")
        if w:adjust_options_for_width_previous_width == cols
          # unchanged from last check
          return
        endif
      endif
      w:adjust_options_for_width_previous_width = cols

      if !(empty(&buftype) && &buflisted)
        # special buffers can manage themselves!
        w:adjust_options_for_width_ignored = true
        return
      endif

      if 100 <= cols
        # wide enough to support all of my preferred features
        setlocal nowrap               # don't use line-wrapping by default
        setlocal number               # line numbers
        setlocal numberwidth=5        # spacious
        if &l:signcolumn != "yes"     # setting signcolumn always flashes screen
          setlocal signcolumn=yes     # always display sign column
        endif
        g:auto_origami_foldcolumn = 5 # spacious

      elseif 90 <= cols
        # narrow, but usable
        setlocal wrap                 # narrow screens need to wrap
        setlocal number               # line numbers
        setlocal numberwidth=4        # good enough for most files
        if &l:signcolumn != "number"  # setting signcolumn always flashes screen
          setlocal signcolumn=number  # merged sign and number columns
        endif
        g:auto_origami_foldcolumn = 2 # not much!

      elseif 85 <= cols
        # too narrow for everything
        setlocal wrap                 # narrow screens need to wrap
        setlocal number               # line numbers
        setlocal numberwidth=1        # use only as much space as necessary
        if &l:signcolumn != "number"  # setting signcolumn always flashes screen
          setlocal signcolumn=number  # merged sign and number columns
        endif
        g:auto_origami_foldcolumn = 1 # nearly nothing

      else
        # very narrow screen
        setlocal wrap                 # narrow screens need to wrap
        setlocal nonumber             # too narrow. so sad (use the statusbar)
        if &l:signcolumn != "hide"    # setting signcolumn always flashes screen
          setlocal signcolumn=auto    # auto-hide when not in use
        endif
        g:auto_origami_foldcolumn = 0 # no foldcolumn at all (can still fold)
      endif

    enddef
    defcompile
  endif

augroup END

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" TERM/TERMINFO/COLORTERM, mouse, tmux, etc                              {{{1
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

if !has('gui_running')

  if &mouse =~# 'a'
    set mouse-=a     " some terminals won't or can't override app mouse control
    set mouse+=nvi   " let terminal control mouse (& clipboard) in command mode
  endif

  if &term =~ '^\%(screen\|tmux\)'
      " Better mouse support, see  :help 'ttymouse'
      set ttymouse=sgr

      " Enable bracketed paste mode, see  :help xterm-bracketed-paste
      let &t_BE = "\<Esc>[?2004h"
      let &t_BD = "\<Esc>[?2004l"
      let &t_PS = "\<Esc>[200~"
      let &t_PE = "\<Esc>[201~"

      " Enable focus event tracking, see  :help xterm-focus-event
      let &t_fe = "\<Esc>[?1004h"
      let &t_fd = "\<Esc>[?1004l"
      execute "set <FocusGained>=\<Esc>[I"
      execute "set <FocusLost>=\<Esc>[O"

      " Enable modified arrow keys, see  :help arrow_modifiers
      execute "silent! set <xUp>=\<Esc>[@;*A"
      execute "silent! set <xDown>=\<Esc>[@;*B"
      execute "silent! set <xRight>=\<Esc>[@;*C"
      execute "silent! set <xLeft>=\<Esc>[@;*D"
  endif

  if $COLORTERM =~ '^\%(truecolor\|24bit\)$' || $TERM =~# '-direct$'
    " 256 colors (not 16M) because t_Co is for the *palette* of *indexed* colors
    " i.e. it's the difference between setaf/setab and setrgbf/setrgbb.
    " At least, that's how ncurses and tput interpret it. vim may be different?
    if empty(&t_Co) | let &t_Co = 256 | endif
    " these are only set automatically for xterm-*... :(
    if empty(&t_8f) | let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum" | endif
    if empty(&t_8b) | let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum" | endif
    let &termguicolors = v:true
  endif

endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim modeline... {{{1
" vim: wrap fdm=marker
