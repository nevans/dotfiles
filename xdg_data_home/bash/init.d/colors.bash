# enable color support of ls and also add handy aliases
if hash vivid 2>/dev/null; then
    LS_COLORS="$(vivid generate one-dark)"
    export LS_COLORS
elif hash dircolors 2>/dev/null; then
    # TODO: eval $(dircolors "$XDG_CONFIG_HOME"/dircolors)
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi

ncolors=$(command -v tput &>/dev/null && tput colors)
if [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'

    # colored GCC warnings and errors
    export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
fi
