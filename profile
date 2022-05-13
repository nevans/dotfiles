# ~/.profile: executed by the command interpreter for login shells.
# This file is not read by bash(1), if ~/.bash_profile or ~/.bash_login
# exists.
# see /usr/share/doc/bash/examples/startup-files for examples.
# the files are located in the bash-doc package.

# if running bash, include .bashrc if it exists
if [ -n "$BASH_VERSION" ] && [ -f "${HOME:-~}/.bashrc" ]; then
    # shellcheck source=bashrc
    . "${HOME:-~}/.bashrc"
else
    # running some other POSIX compatible shell?
    # shellcheck source=xdg_data_home/shell/profile-init.sh
    . "${XDG_DATA_HOME:-${HOME:-~}/.local/share}/shell/profile-init.sh"
fi

#  add ~/.local/bin and ~/bin to $PATH
for p in "$HOME/bin" "$HOME/.local/bin"; do
    if [ -d "$p" ]; then case :$PATH: in *:$p:*);; *) PATH="$p:$PATH";; esac; fi
done

# vim:ft=sh
