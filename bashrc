# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# prevent multiple loads (don't export bashrc_loaded)
if [[ -n "$bashrc_loaded" ]]; then return 0; else bashrc_loaded=1; fi

# always init all of the paths env vars, and the helper fns for them
# shellcheck source=xdg_data_home/shell/profile-init.sh
. "${XDG_DATA_HOME:-${HOME:-~}/.local/share}/shell/profile-init.sh"

# load nothing else when running non-interactively or in POSIX-mode
[[ -z "$PS1" ]] && return 0
case $-           in       *i*)        ;; *) return ;; esac
case :$SHELLOPTS: in *:posix:*) return ;; *)        ;; esac

# common setup and configuration
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
