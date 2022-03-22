NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="$NPM_PACKAGES/bin:$PATH"
export MANPATH="$NPM_PACKAGES/share/man:$MANPATH"

if [ -d "$NPM_PACKAGES/bin" ]; then
  export PATH="$NPM_PACKAGES/bin:$PATH"
fi

yarn_bin_path="$HOME/.yarn/bin"
if [ -d "$yarn_bin_path" ]; then
  export PATH="$yarn_bin_path:$PATH"
fi
