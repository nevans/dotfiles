if [ -d "$HOME/src/go" ]; then
  export GOPATH=$HOME/src/go
  path_append PATH "$GOPATH/bin"
fi

path_append PATH "$HOME/golang/bin"
