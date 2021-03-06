if [ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash ]; then
  source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.bash
fi

if hash fdfind 2>/dev/null; then
  # Use fd (https://github.com/sharkdp/fd) instead of the default find
  # command for listing path candidates.
  # - The first argument to the function ($1) is the base path to start traversal
  # - See the source code (completion.{bash,zsh}) for the details.
  _fzf_compgen_path() {
    fdfind --hidden --follow --exclude ".git" . "$1"
  }

  # Use fd to generate the list for directory completion
  _fzf_compgen_dir() {
    fdfind --type d --hidden --follow --exclude ".git" . "$1"
  }
fi

# (EXPERIMENTAL) Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf "$@" --preview 'tree -C {} | head -200' ;;
    export|unset) fzf "$@" --preview "eval 'echo \$'{}" ;;
    ssh)          fzf "$@" --preview 'dig {}' ;;
    *)            fzf "$@" ;;
  esac
}

_fzf_setup_completion path ag git kubectl
_fzf_setup_completion dir tree
