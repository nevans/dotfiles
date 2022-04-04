################################################################################
# default debian/ubuntu aliases.
################################################################################

# enable color support of ls and also add handy aliases
if hash vivid 2>/dev/null; then
    LS_COLORS="$(vivid generate one-dark)"
    export LS_COLORS
elif hash dircolors 2>/dev/null; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
fi
ncolors=$(tput colors)
if [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# some more ls aliases
alias ll='ls -AlshF'
alias la='ls -alshF'
alias  l='ls  -lshF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
