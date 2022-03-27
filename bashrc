# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in *i*) ;; *) return;; esac
[ -z "$PS1" ] && return
[ -n "$bashrc_loaded" ] && return
export bashrc_loaded=1

# common functions used by other init scripts
. "$HOME/.config/shell/fns.sh"
source_dot_d "bash/fns.d"

# machine-specific, personal, or private
source_dot_d "local/shell/preinit.d"
source_dot_d "local/bash/preinit.d"

# generic configs
source_dot_d "shell/init.d"
source_dot_d "bash/init.d"

# machine-specific, personal, or private
source_dot_d "local/shell/init.d"
source_dot_d "local/bash/init.d"

# ensure ~/bin:.local/bin are first in PATH, if they exist
path_prepend PATH "$HOME/.local/bin"
path_prepend PATH "$HOME/bin"

# vim:ft=bash
