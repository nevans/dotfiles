# Can use rbenv from $HOME or from system package.
# Debian/Ubuntu package rbenv ok.
#
# But ruby-build is usually *very* out of date!

rbenv_path="$HOME/.rbenv/bin"
ruby_build_path="$HOME/.rbenv/plugins/ruby-build/bin"

path_prepend PATH "$rbenv_path"
path_prepend PATH "$ruby_build_path"

if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi
