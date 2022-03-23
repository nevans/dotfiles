path_append ()  {
  local -n ref=$1
  local    val=$2
  path_remove "$1" "$2"
  if [ -d "$ref" ]; then
    ref="$ref:$val"
  fi
}

path_prepend () {
  local -n ref=$1
  local    val=$2
  path_remove "$1" "$2"
  if [ -d "$ref" ]; then
    ref="$val:$ref"
  fi
}

path_remove ()  {
  local -n ref=$1
  local    val=$2
  ref=":$ref:"
  ref="${ref//::/:}"
  ref="${ref//:$val:/:}"
  ref="${ref%:}"
  ref="${ref#:}"
}
