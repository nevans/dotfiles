# adapted from https://stackoverflow.com/a/18873979/5289571
function get_stack () {
   STACK=""
   # to avoid noise we start with 1 to skip get_stack caller
   local i
   local stack_size=${#FUNCNAME[@]}
   for (( i=1; i<stack_size ; i++ )); do
      local func="${FUNCNAME[$i]}"
      [ "x$func" = x ] && func=MAIN
      local linen="${BASH_LINENO[(( i - 1 ))]}"
      local src="${BASH_SOURCE[$i]}"
      [ x"$src" = x ] && src=non_file_source
      STACK=$(printf "%s\n%-20s %-50s %s" "$STACK" "$func" "$src" "$linen")
   done
}

