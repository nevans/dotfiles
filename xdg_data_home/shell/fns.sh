source_config_files () {
  for script in "$@"; do cond_source_script "$script"; done
}

cond_source_script () {
    # shellcheck source=/dev/null
    if [ -f "${1:-}" ]; then . "$1"; fi
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
  if [ -z ${2+set} ]; then : "${2?missing path var ref or removed dir}"; fi

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
        : removing :"$dir": -- "${orig%%:$dir:*}"
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
  if [ -z ${2+set} ]; then : "${2?missing path var ref or appended dir}"; fi
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
  if [ -z ${2+set} ]; then : "${2?missing path var ref or prepended dir}"; fi
  eval "local dirs=\"\${${ref}:-}\""
  if [ -z "$dirs" ]; then
    dirs="$dir"
  else
    dirs="$dir:$dirs"
  fi
  eval "$ref=\$dirs"
  # echo "$ref=$dirs prepended $dir"
}

cond_path_append ()  { if [ -d "$1" ]; then path_prepend "$1"; fi; }
cond_path_prepend () { if [ -d "$1" ]; then path_append  "$1"; fi; }

_xdg_runtime_dir_fallback_assign () {
  if [ -n "${XDG_RUNTIME_DIR:-}" ]; then return 0; fi
  # shellcheck disable=SC2039
  uid=${UID:-$(id -un)} # $UID is readonly in bash, but undefined in POSIX
  # try the usual systemd path...
  XDG_RUNTIME_DIR="/run/user/$uid"
  if [ ! -d "${XDG_RUNTIME_DIR}" ]; then
    # try dir in $TMPDIR or /tmp
    XDG_RUNTIME_DIR="${TMPDIR:-/tmp}/$uid-runtime"
    if [ ! -d "${XDG_RUNTIME_DIR}" ]; then
      # doesn't exist yet
      mkdir -m 0700 "$XDG_RUNTIME_DIR"
    fi
  fi
  unset uid
  # `ls` is the only POSIX-compatible perms+owner check.
  # This is already a fallback, so I'm not going to optimize for bash or zsh.
  # shellcheck disable=SC2012
  perms="$(ls -ldn "$XDG_RUNTIME_DIR" | awk '{print $1, $3}')"
  if [ "drwx------ $(id -u)" != "$perms" ]; then
    # invalid permissions
    # TODO: warning msg on stderr?
    XDG_RUNTIME_DIR=$(mktemp -d "${TMPDIR:-/tmp}/$(id -un)-runtime-XXXXXX")
  fi
  unset perms
  export XDG_RUNTIME_DIR
}
