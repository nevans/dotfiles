################################################################################
# default debian/ubuntu completion. Added PREFIX for termux
################################################################################

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  export BASH_COMPLETION_USER_FILE="$XDG_CONFIG_HOME"/bash_completion
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion

  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion

  elif [ -n "$PREFIX" ] && [ -n "$TERMUX_VERSION" ]; then
    if [ -f "$PREFIX"/usr/share/bash-completion/bash_completion ]; then
      . "$PREFIX"/usr/share/bash-completion/bash_completion
    elif [ -f "$PREFIX"/etc/bash_completion ]; then
      . "$PREFIX"/etc/bash_completion
    fi

  fi
fi

############################################################################
# kubectl
############################################################################
if command -v kubectl &>/dev/null; then
  eval "$(kubectl completion bash)"
fi
