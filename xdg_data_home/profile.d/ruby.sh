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
