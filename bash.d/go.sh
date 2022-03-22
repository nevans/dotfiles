if [ -d "$HOME/src/go" ]; then
  export GOPATH=$HOME/src/go
  export PATH=$PATH:$GOPATH/bin
fi

if [ -d "$HOME/golang/bin" ]; then
  export PATH="$PATH:$HOME/golang/bin"
fi
