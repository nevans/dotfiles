if [ -d "$XDG_DATA_HOME/go" ]; then
  export GOPATH="$XDG_DATA_HOME"/go
  path_append PATH "$GOPATH/bin"
elif [ -d "$HOME/src/go" ]; then
  export GOPATH=$HOME/src/go
  path_append PATH "$GOPATH/bin"
fi
