# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
[[ $- =~ "i" ]] || return 0
[[ -z "$PS1" ]] && return 0
[[ -n "$bashrc_loaded" ]] && return 0

# common functions used by other init scripts
# TODO: move "shell" stuff to "profile"
# TODO: move most env var settings to "profile"
. "$HOME/.config/shell/fns.sh"
source_config_files "$HOME"/.config/bash/fns.d/*.bash

# machine-specific, personal, or private
source_config_files "$HOME"/.config/local/shell/preinit.d/*.sh
source_config_files "$HOME"/.config/local/bash/preinit.d/*.bash

source_config_files "$HOME"/.config/shell/init.d/*.sh
source_config_files "$HOME"/.config/local/shell/init.d/*.sh

source_config_files "$HOME"/.config/bash/init.d/*.bash
source_config_files "$HOME"/.config/local/bash/init.d/*.bash

# ensure ~/bin:.local/bin are first in PATH
path_prepend PATH "$HOME/.local/bin"
path_prepend PATH "$HOME/bin"
# ensure "" and "." didn't sneak in
path_remove  PATH ""
path_remove  PATH "."

bashrc_loaded=1
# vim:ft=bash
