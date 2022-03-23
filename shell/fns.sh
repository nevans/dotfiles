source_dot_d () {
  local path="$HOME/.config/$1"
  if [ -d "$path" ]; then
    for script in $path/*; do
      # shellcheck source=/dev/null
      . "$script"
    done
  fi
}
