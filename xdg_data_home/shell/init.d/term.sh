# only when stdin and stdout are TTY
[ -t 0 ]      || return 0
[ -t 1 ]      || return 0
# only when sourced for interactive shells
[ -n "$PS1" ] || return 0

# See term.md for a "discussion" of the approach taken here.

# TODO: query the terminal... but maybe not in this file?
# This may be unwise to do inside .profile scripts?

if [ -z "${COLORTERM-}" ]; then
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
    *direct      |\
    *-256color   )
      # Strictly speaking, this is wrong.  Pragmatically: there isn't a single
      # terminal I'd use in 2022 that supports 256color but not 24bit RGB.
      #
      # Normally, these terminals all set COLORTERM already.
      # The most likely reason to be here is in an ssh session which lost the var.
      export COLORTERM=truecolor
      ;;
  esac
else
  if [ "$COLORTERM" = "24bit" ]; then
    COLORTERM=truecolor # this seems to be more widely supported
  fi
  if [ "$COLORTERM" = "truecolor" ]; then
    # Many terminals set COLORTERM=truecolor, but use TERM=$term-256color.
    # "official" terminfo recommendation seems to be to use TERM=$term-direct
    # instead.  But that's backwards incompatible with ANSI 8/16/256 colors!
    #
    # Better solution: add "Tc", "setrgbf", and "setrgbb" to 256color terminfos.
    case $TERM in
      xterm) TERM=xterm-256color ;; # TODO: add "Tc", "setrgbf", and "setrgbb"
      tmux)  TERM=tmux-256color  ;; # TODO: add "Tc", "setrgbf", and "setrgbb"
    esac
  fi
fi

# Unfortunately, some apps still rely at least partially on hardcoded TERM
# names, without querying terminfo or the terminal.  This is one reason why so
# many terminal emulators report "TERM-xterm-$term".
