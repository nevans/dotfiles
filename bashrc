# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[[ $- =~ "i" ]] || return 0
[[ -z "$PS1" ]] && return 0
[[ -n "$bashrc_loaded" ]] && return 0
export bashrc_loaded=1

# common functions used by other init scripts
# TODO: move "shell" stuff to "profile"
# TODO: move most env var settings to "profile"
. "$HOME/.config/shell/fns.sh"
source_config_dir "bash/fns.d"

# machine-specific, personal, or private
source_config_dir "local/shell/preinit.d"
source_config_dir "local/bash/preinit.d"

source_config_dir "shell/init.d"
source_config_dir "local/shell/init.d"

source_config_dir "bash/init.d"
source_config_dir "local/bash/init.d"

# ensure ~/bin:.local/bin are first in PATH
path_prepend PATH "$HOME/.local/bin"
path_prepend PATH "$HOME/bin"

# vim:ft=bash
