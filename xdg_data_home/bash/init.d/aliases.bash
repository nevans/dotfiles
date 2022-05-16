################################################################################
# default debian/ubuntu aliases.
################################################################################

# some more ls aliases
alias ll='ls -AlshF'
alias la='ls -alshF'
alias  l='ls  -lshF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

################################################################################
# a few very common aliases that I'm surprised aren't defaults in Ubuntu
################################################################################

# these are not safe otherwise!
alias rm="rm -i"
alias cp="cp -i"
alias mv="mv -i"

# nicer default opts for common commands
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias mkdir='mkdir -p'
alias ln='ln -v'

################################################################################
# etc...
################################################################################

# jump to git repository root dir
alias cg='cd $(git rev-parse --show-toplevel)'

alias -- -='cd -'                   # switch to previou dir
alias ..='cd ..'                    # 1 up - redundant with shopt -s autocd
alias ...='cd ../..'                # 2 up
alias ....='cd ../../..'            # 3 up
alias .....='cd ../../../..'        # 4 up
alias ......='cd ../../../../..'    # 5 up

# ruby
alias b='bundler'
alias bx='bundler exec'
