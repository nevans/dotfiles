# supports XDG automatically:
#   * tmux v3.2 (v3.1 can use hardcoded ~/.config/tmux)

# for ruby config, see ./ruby.sh
# for go config, see ./go.sh
# for nodejs config, see ./node.sh

# Copied and adapted from https://wiki.archlinux.org/title/XDG_Base_Directory
# Because polluting our environment is better than polluting $HOME 😏,
# Many many env vars instructing other apps to honor XDG base dir spec:

path_prepend MANPATH "$XDG_DATA_HOME/man"
path_append MANPATH ""  # ensure the defaults are honored

export ACKRC="$XDG_CONFIG_HOME/ack/ackrc"
export DOCKER_CONFIG="$XDG_CONFIG_HOME"/docker
export FFMPEG_DATADIR="$XDG_CONFIG_HOME"/ffmpeg
export INPUTRC="$XDG_CONFIG_HOME"/readline/inputrc
export LESSHISTFILE="$XDG_STATE_HOME/lesshist"
export PASSWORD_STORE_DIR="$XDG_DATA_HOME"/pass
export RIPGREP_CONFIG_PATH=$XDG_CONFIG_HOME/ripgrep/config
export SCREENRC="$XDG_CONFIG_HOME"/screen/screenrc

# TODO: vim—but I'd rather not use $VIMINIT.
# TODO: GPG... it's complicated. (see Arch wiki)
