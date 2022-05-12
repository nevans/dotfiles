# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# prevent multiple loads (don't export)
[[ -n "$bashrc_loaded" ]] && return 0
bashrc_loaded=1

# the fns and paths used in this script
. "${XDG_DATA_HOME:-$HOME/.local/share}/shell/fns.sh"
. "${XDG_DATA_HOME:-$HOME/.local/share}/shell/xdg.sh"

# mostly for satting various path-related environment vars
source_config_files "$XDG_DATA_HOME"/profile.d/*.sh
source_config_files "$XDG_CONFIG_HOME"/profile.d/*.sh

# load nothing else, unless running interactively
[[ $- =~ "i" ]] || return 0
[[ -z "$PS1" ]] && return 0

# common setup used by other init scripts
source_config_files "$XDG_DATA_HOME"/shell/init.d/*.sh
source_config_files "$XDG_DATA_HOME"/bash/init.d/*.bash

# machine-specific, personal, or private
source_config_files "$XDG_CONFIG_HOME"/shell/init.d/*.sh
source_config_files "$XDG_CONFIG_HOME"/bash/init.d/*.bash

# ensure ~/bin:~/.local/bin are first in PATH
path_prepend PATH "$HOME/.local/bin"
path_prepend PATH "$HOME/bin"
# ensure "" and "." didn't sneak in
path_remove  PATH ""
path_remove  PATH "."

# vim:ft=bash
