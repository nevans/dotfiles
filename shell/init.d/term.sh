# only when sourced for interactive shells
[ -t 0 ]      && return 0
[ -z "$PS1" ] && return 0

# Ideally apps would just query the terminal during initialization, e.g. using
# DECRQSS.  Unfortunately, that isn't simple or reliable.
#
# In order to make everything work properly, the basic approach is as follows:
# 1) an up-to-date terminfo DB (possibly in ~/.terminfo)
# 2) an *appropriate* TERM variable for each terminal emulator, e.g: not xterm-*

# TODO: query the terminal... but not in this file...
# probably not safe to do inside

# Unfortunately, the primary terminfo DB maintainer has been reluctant to
# accomodate certain new extensions, even though they have achieved widespread
# support elsewhere among terminal emulator implementations.  Most notably:
# 24bit RGB support via Tc, rgb, setrgbf, and setrgbb.  And for whatever reason,
# people often just skip terminfo/termcap and hardcode anyway.  So, instead of
# using terminfo, many programs look at the $TERM and $COLORTERM environment
# variables.
#
# So we'll also set a matching COLORTERM, for compatibility:
# 1) always set $COLORTERM in supporting terminals (easy)
# 2) always send $COLORTERM through SSH (not always possible)
# 3) If we can trust our terminfo DB, we can use `tput colors` to set COLORTERM

if [ -n "${COLORTERM-}" ]; then
  if [ "$COLORTERM" = "truecolor" ] || [ "$COLORTERM" = "24bit" ]; then
    # Many terminals set COLORTERM=truecolor, but use TERM=$term-256color.
    # WEIRD.  Just use $term-direct or $term-truecolor instead!
    case $TERM in
      xterm-256color) TERM=xterm-direct ;; # in ncurses-term package
      tmux-256color)  TERM=tmux-direct  ;; # in ncurses-term package
      # I'm cheating with the above. It'll break older versions of tmux, etc.
      # So... use up-to-date tmux!
    esac
  fi
else
  case $TERM in
    *alacritty*  |\
    iTerm*.app   |\
    *kitty*      |\
    mintty       |\
    ms-terminal* |\
    nsterm*      |\
    *terminator* |\
    terminology* |\
    termite*     |\
    vscode*      |\
    iterm*       |\
    *truecolor   |\
    *direct      )
      # this is a lousy way to handle it... but it works!
      export COLORTERM=truecolor
      ;;
  esac

  # Unfortunately, `tput colors` only returns 256--the result needs to fit in a
  # 16-bit integer!
fi

# Unfortunately, some apps will always check against hardcoded TERM names,
# without querying terminfo or tput.  Some options for these programs:
# 1) or update their config (or send a PR) to do it "the right way"
# 2) create a shell script or alias that sets a different TERM env var
# 3) create a terminfo alias like xterm-$REALTERM => $REALTERM
#
# e.g. my vimrc sets various termcap values based on TERM or COLORTERM
