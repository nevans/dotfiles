export XDG_DATA_HOME=${XDG_DATA_HOME:-$HOME/.local/share}
export XDG_CACHE_HOME=${XDG_CACHE_HOME:-$HOME/.cache}
export XDG_STATE_HOME=${XDG_STATE_HOME:-$HOME/.local/state}
export XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

path_prepend MANPATH         "$XDG_DATA_HOME/man"
path_prepend PATH            "$HOME/.local/bin"
path_prepend XDG_DATA_DIRS   "$XDG_DATA_HOME"
path_prepend XDG_CONFIG_DIRS "$XDG_CONFIG_HOME"
export XDG_DATA_DIR
export XDG_CONFIG_DIRS
