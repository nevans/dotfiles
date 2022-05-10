(
  set -eu
  umask -S u=rwx,g=,o=
  [ -e "$HOME/.local/bin" ] || mkdir -p "$HOME/.local/bin"
  [ -e "$XDG_CACHE_HOME"  ] || mkdir -p "$XDG_CACHE_HOME"
  [ -e "$XDG_CONFIG_HOME" ] || mkdir -p "$XDG_CONFIG_HOME"
  [ -e "$XDG_DATA_HOME"   ] || mkdir -p "$XDG_DATA_HOME"
  [ -e "$XDG_STATE_HOME"  ] || mkdir -p "$XDG_STATE_HOME"
) > /dev/null 2>&1


