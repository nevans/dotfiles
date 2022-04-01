source_config_dir () {
  local path="$HOME/.config/$1"
  if [ -d "$path" ]; then
    for script in $path/*; do
      [ -f "$script" ] || continue
      # shellcheck source=/dev/null
      . "$script"
    done
  fi
}

# This is *so* complicated compared to modern shells!
# it's also simpler to shell out to sed, but this uses only builtins.
#
# taken from stackoverflow.com/a/39342174/5289571
#
# Modified to return result via variable named by $1, to avoid subshells.
esc_posixly () {
  local ref=$1
  local unescaped=$2
  local escaped=
  while :
  do
    case $unescaped in
      *\'*)
        escaped="${escaped}${unescaped%%\'*}'\''"
        unescaped=${unescaped#*\'}
        ;;
      *)
        escaped="${escaped}${unescaped}"
        break
        ;;
    esac
  done
  escaped="'${escaped}'"
  if [ -z "$ref" ] || [ "-" = "$ref" ]
  then
    printf %s "$escaped"
  else
    eval "$ref=\$escaped"
  fi
}

posixly_varlike () {
  case $1 in
    (*[!A-Za-z_0-9]*) false;;
    (*)             true;;
  esac
}

# TODO: loop to remove all matches.
path_remove () {
  local ref="${1:?missing path var ref}"
  local dir="${2:?missing removed dir}"

  eval "local dirs=\$$ref"
  # echo "$ref=$dirs removing $dir"
  dirs=":$dirs:"

  # bash: dirs="${dirs//:$dir:/:}"
  local prefix="${dirs%%:$dir:*}"
  local suffix="${dirs#*:$dir:}"
  if [ "$prefix" != "$suffix" ]; then
    dirs="${prefix}:${suffix}"
  fi
  # unlike bash, only removes first match
  # and empty segments aren't removed.

  dirs="${dirs%:}"
  dirs="${dirs#:}"

  # echo "$ref=$dirs removed $dir"
  eval "$ref=\$dirs"
}

path_append ()  {
  path_remove "${@}"
  local ref="${1:?missing path var ref}"
  local dir="${2:?missing appended dir}"
  eval "local dirs=\"\${${ref}:-}\""
  if [ -z "$dirs" ]; then
    dirs="$dir"
  else
    dirs="$dirs:$dir"
  fi
  eval "$ref=\$dirs"
  # echo "$ref=$dirs appended $dir"
}

path_prepend () {
  path_remove "${@}"
  local ref="${1:?missing path var ref}"
  local dir="${2:?missing prepended dir}"
  eval "local dirs=\"\${${ref}:-}\""
  if [ -z "$dirs" ]; then
    dirs="$dir"
  else
    dirs="$dir:$dirs"
  fi
  eval "$ref=\$dirs"
  # echo "$ref=$dirs prepended $dir"
}
