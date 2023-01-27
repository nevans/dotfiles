# the default umask is probably set by /etc/profile or /etc/login.defs.
# Either way, the historical default umask 022 is far too permissive.
umask 022

# I like vim.
export EDITOR=vim
export VISUAL=vim

# Until everyone everywhere uses UTC, I'll need to use the local TZ.
export TZ="America/New_York"

# my locale
export LANG=en_US.UTF-8
