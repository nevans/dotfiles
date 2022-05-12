# FYI: PATH updated by .local/shre/profile.d

# Can use rbenv from $HOME or from system package.
# Debian/Ubuntu package rbenv ok.
#
# But ruby-build is usually *very* out of date!

if command -v rbenv >/dev/null 2>&1; then
  eval "$(rbenv init -)"
fi
