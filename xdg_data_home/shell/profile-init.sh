# The default umask is probably set by /etc/profile or /etc/login.defs.
# Either way, the historical default umask 022 is far too permissive.
umask 077

# This *really* should be set already.  Just In Case:
if [ -z "$HOME" ]; then HOME=~; fi

# Ensure the XDG vars are set
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"
export XDG_CONFIG_DIRS="${XDG_CONFIG_DIRS:-/etc/xdg}"
export XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"

# get some basic utility fns
# shellcheck source=fns.sh
. "$XDG_DATA_HOME/shell/fns.sh"

# trust $XDG_RUNTIME_DIR without checking perms, if it's already set
if [ -z "${XDG_RUNTIME_DIR:-}" ]; then _xdg_runtime_dir_fallback_assign; fi

cond_path_prepend PATH "$HOME/.local/bin"

# Load all of the profile.d scripts
source_config_files "$XDG_DATA_HOME"/profile.d/*.sh
source_config_files "$XDG_CONFIG_HOME"/profile.d/*.sh

# will be moved to the front again at the end of bashrc
path_prepend PATH "$HOME/.local/bin"
