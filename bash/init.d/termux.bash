 [ -z "$TERMUX_VERSION" ] && return

# change these to something more useful.
# n.b. this has no affect on e.g. ssh's default user
if [ -z "$TERMUX_PRESERVE_USER_HOST" ]; then
  USER=termux
  HOSTNAME=$(getprop ro.product.vendor.model)
fi
