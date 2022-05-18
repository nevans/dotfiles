# n.b: moving rbenv or rustup or cargo, etc from $HOME to $XDG_DATA_HOME may
# require reinstallation of some things,  Just moving the dirs won't completely
# work

############################################################################
# Android SDK                                                              #{{{1
cond_path_append "$HOME/src/vendor/android-sdk-linux/tools"
cond_path_append "$HOME/src/vendor/android-sdk-linux/platform-tools"

############################################################################
# Elm                                                                      #{{{1
export ELM_HOME="$XDG_CONFIG_HOME"/elm

############################################################################
# rust                                                                     #{{{1
#
# last time I checked, all the env file does is add the bin dir to the PATH
# but it might do more in other circumstances or in the future?
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
export CARGO_HOME="$XDG_DATA_HOME"/cargo
cond_source_script "$CARGO_HOME/env"

############################################################################
# golang                                                                   #{{{1
if [ -d "$HOME/src/go" ]; then
  export GOPATH=$HOME/src/go
else
  export GOPATH="$XDG_DATA_HOME"/go
fi
cond_path_append PATH "$GOPATH/bin"

############################################################################
# nodejs                                                                   #{{{1
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

############################################################################
# Ruby                                                                     #{{{1

if [ -d "$XDG_DATA_HOME/rbenv" ]; then
  export RBENV_ROOT=$XDG_DATA_HOME/rbenv
elif [ -d "$HOME/.rbenv" ]; then
  # fallback for non-XDG_DATA_HOME installs
  export RBENV_ROOT=$HOME/.rbenv
elif [ -z "$RBENV_ROOT" ]; then
  # default to XDG, if neither have been created yet.
  export RBENV_ROOT=$XDG_DATA_HOME/rbenv
fi

if [ -d "$RBENV_ROOT" ]; then
  path_prepend PATH "$RBENV_ROOT/bin"
  path_prepend PATH "$RBENV_ROOT/plugins/ruby-build/bin"
  # n.b. "rbenv init -" will re-add the shims dir in interactive shells
  # But this places all of the shims on PATH for non-interactive shells.
  path_prepend PATH "$RBENV_ROOT/shims"
fi

# TODO: also support chruby... maybe switch to it?

export SOLARGRAPH_CACHE=$XDG_CACHE_HOME/solargraph

# current releases support XDG automatically:
#   * rubygems
#   * bundler
#   * irb
#   * rubocop
#   * rspec
#
# If any of these are still using old paths, try upgrading or moving the files.
# They may continue using the old paths for backwards compatibility.

############################################################################}}}1
# vim: foldmethod=marker
