################################################################################
# I've uncommented/deleted/adjusted a few lines, but a lot is debian defaults.
################################################################################

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth
HISTCONTROL=erasedups:$HISTCONTROL

export HISTIGNORE="&:[ ]*:exit:ls:bg:fg:history:clear"

# more like ISO 8601
HISTTIMEFORMAT='%F %T '

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=5000
HISTFILESIZE=10000

export HISTFILE="$XDG_STATE_HOME"/bash_history

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
shopt -s globstar

# Case-insensitive globbing (used in pathname expansion)
shopt -s nocaseglob

# Prevent file overwrite on stdout redirection
# Use `>|` to force redirection to an existing file
set -o noclobber

# a command name that is the name of a directory is executed as if it were the
# argument to the cd command.
shopt -s autocd

# spelling correction on directory names during word completion if the directory
# name initially supplied does not exist.
shopt -s dirspell

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"
