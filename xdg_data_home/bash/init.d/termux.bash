[ -z "$TERMUX_VERSION" ] && return

# change these to something more useful.
# n.b. this has no affect on e.g. ssh's default user
# TODO: conditionally change the PROMPT, rather than break these two vars.
if [ -z "$TERMUX_PRESERVE_USER_HOST" ]; then
  USER=termux
  HOSTNAME=$(getprop ro.product.vendor.model)
fi
