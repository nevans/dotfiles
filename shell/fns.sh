source_config_files () {
  for script in "$@"; do
    [ -f "$script" ] || continue
    # shellcheck source=/dev/null
    . "$script"
  done
}

# This is *so* complicated compared to modern shells!
# it's also simpler to shell out to sed, but this uses only builtins.
#
# taken from stackoverflow.com/a/39342174/5289571
#
# Modified to return result via variable named by $1, to avoid subshells.
esc_posixly () {
  ref=$1
  unescaped=$2
  escaped=
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

path_remove () {
  ref="${1:?missing path var ref}"
  if [ -z ${2+set} ]; then : "${2?missing removed dir}"; fi

  dir=$2
  eval "orig=\$$ref"
  updated=
  while :
  do
    case $orig in
      $dir:*)
        : removing "$dir":
        orig=${orig#$dir:}
        ;;
      *:$dir:*)
        : removing :"$dir": -- ${orig%%:$dir:*}
        updated="${updated}${orig%%:$dir:*}:"
        orig=${orig#*:$dir:}
        ;;
      *:$dir)
        : removing :"$dir"
        updated="${updated}${orig%%":$dir"}"
        break;
        ;;
      "$dir")
        : remove only "$dir"
        break
        ;;
      *)
        : no "$dir" found
        updated="${updated}${orig}"
        break
        ;;
    esac
  done

  # echo "$ref=$updated removed $dir"
  eval "$ref=\$updated"
}

path_append ()  {
  path_remove "${@}"
  ref="${1:?missing path var ref}"
  if [ -z ${2+set} ]; then : "${2?missing appended dir}"; fi
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
  ref="${1:?missing path var ref}"
  if [ -z ${2+set} ]; then : "${2?missing prepended dir}"; fi
  eval "local dirs=\"\${${ref}:-}\""
  if [ -z "$dirs" ]; then
    dirs="$dir"
  else
    dirs="$dir:$dirs"
  fi
  eval "$ref=\$dirs"
  # echo "$ref=$dirs prepended $dir"
}
