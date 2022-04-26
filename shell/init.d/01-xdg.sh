export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

export XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:-/etc/xdg}"
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"

path_prepend PATH "$HOME/.local/bin"

(
  umask -S u=rwx,g=,o=
  mkdir -p "$HOME/.local/bin"
  mkdir -p "$XDG_CACHE_HOME"
  mkdir -p "$XDG_CONFIG_HOME"
  mkdir -p "$XDG_DATA_HOME"
  mkdir -p "$XDG_STATE_HOME"
) > /dev/null 2>&1

if [ -z "$MANPATH" ]; then
  export MANPATH="$XDG_DATA_HOME/man:"
else
  path_prepend MANPATH "$XDG_DATA_HOME/man"
fi
