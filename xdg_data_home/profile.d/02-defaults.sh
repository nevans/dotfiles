# the default umask is probably set by /etc/profile or /etc/login.defs.
# Either way, the historical default umask 022 is far too permissive.
umask 077

# I like vim.
export EDITOR=vim

# Until everyone everywhere uses UTC, I'll need to use the local TZ.
export TZ="America/New_York"
