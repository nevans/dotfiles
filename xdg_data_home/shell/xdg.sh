export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:-/etc/xdg}"
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"

path_prepend PATH "$HOME/.local/bin"

# trust $XDG_RUNTIME_DIR without checking perms, if it's already set
if [ -z "${XDG_RUNTIME_DIR:-}" ]; then
  TMPDIR=${TMPDIR:-/tmp}
  # try the usual systemd path...
  XDG_RUNTIME_DIR="/run/user/$UID"
  if [ ! -d "${XDG_RUNTIME_DIR}" ]; then
    # try dir in $TMPDIR or /tmp
    XDG_RUNTIME_DIR="${TMPDIR}/$UID-runtime"
    if [ ! -d "${XDG_RUNTIME_DIR}" ]; then
      # doesn't exist yet
      mkdir -m 0700 "$XDG_RUNTIME_DIR"
    fi
  fi
  perms="$(ls -ldn "$XDG_RUNTIME_DIR" | awk '{print $1, $3}')"
  if [ "drwx------ $(id -u)" != "$perms" ]; then
    # invalid permissions
    # TODO: warning msg on stderr?
    XDG_RUNTIME_DIR=$(mktemp -d "${TMPDIR}/$(id -un)-runtime-XXXXXX")
  fi
  export XDG_RUNTIME_DIR
fi
