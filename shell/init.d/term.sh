# the better alternative to this requires:
# 1) always set $COLORTERM in supporting terminals (easy)
# 2) always send $COLORTERM through SSH (not always possible)
#
# Another alternative would be to send a DECRQSS to the terminal.
# But that isn't always reliable either.

if [ -z "$COLORTERM" ]; then
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
        export COLORTERM=truecolor
        ;;
    xterm-256color)
        # this isn't correct.  but some terminals use it for compatibility,
        # instead of creating a new TERM and TERMINFO.
        # So I'm just going to fudge it for now
        export COLORTERM=truecolor
        ;;
    tmux-256color)
        # tmux didn't support TrueColor until 3.1c?  This will require local
        # installation if it's used on old distros.
        export COLORTERM=truecolor
        ;;
  esac
  # could check version env vars or whatever, but those don't survive through ssh

  # could use fancy queries... but they're complicated and not widely supported.
  # :(

  # Unfortunately, `tput colors` only returns 256--the result needs to fit in a
  # 16-bit integer!
fi

