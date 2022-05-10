export NODE_REPL_HISTORY="$XDG_STATE_HOME/node/repl_history"
export NPM_CONFIG_USERCONFIG="$XDG_CONFIG_HOME/npm/npmrc"
export NPM_PACKAGES="$XDG_DATA_HOME/npm/packages"
export NVM_DIR="$XDG_DATA_HOME/nvm"

if [ -d "$NPM_PACKAGES" ]; then
  path_prepend MANPATH "$NPM_PACKAGES/share/man"
  path_prepend PATH    "$NPM_PACKAGES/bin"
fi
if [ -d "$HOME/.yarn" ]; then
  path_prepend PATH    "$HOME/.yarn/bin"
fi
