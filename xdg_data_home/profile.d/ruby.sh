if [ -d "$XDG_DATA_HOME/rbenv" ]; then
  export RBENV_ROOT=$XDG_DATA_HOME/rbenv
  path_prepend PATH "$RBENV_ROOT/bin"
  path_prepend PATH "$RBENV_ROOT/plugins/ruby-build/bin"
elif [ -d "$HOME/.rbenv" ]; then
  # fallback for non-XDG_DATA_HOME installs
  path_prepend PATH "$HOME/.rbenv/bin"
  path_prepend PATH "$HOME/.rbenv/plugins/ruby-build/bin"
fi

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
