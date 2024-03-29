# FYI: rbenv, plugins, and shims are added to PATH by
# $XDG_DATA_HOME/profile.d/ruby.sh

# Can use rbenv from $HOME or from system package.
# Debian/Ubuntu package rbenv ok-ish.
# But ruby-build is usually *very* out of date!

# This should be safe to run from any POSIX-ish shell.
#   e.g. bash, zsh, dash, but not fish.
# shims will also be re-added to the PATH, completions loaded, rehash called,
# bash extension installed (maybe), and the 'rbenv shell' command enabled.
if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init -)"

  # Clean up devcontainer or codespace that installed both rbenv and rvm
  path_remove PATH /usr/local/rvm/gems/default/bin
  path_remove PATH /usr/local/rvm/gems/default@global/bin
  path_remove PATH /usr/local/rvm/rubies/default/bin
  unset GEM_PATH
  unset GEM_HOME
fi
