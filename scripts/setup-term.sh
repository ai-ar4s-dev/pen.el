#!/bin/bash
export TTY

# This script is sourced

{
stty stop undef; stty start undef
} 2>/dev/null

# Debian10 run Pen

# export PEN_DEBUG=y

export LANG=en_US
export TERM=screen-256color
export LANGUAGE=en_US:en
export LC_ALL=en_US.UTF-8

export EMACSD=/root/.emacs.d
export YAMLMOD_PATH=$EMACSD/emacs-yamlmod
export PATH=$PATH:$EMACSD/host/pen.el/scripts-host:$EMACSD/pen.el/scripts-host
export PATH=$PATH:$EMACSD/host/pen.el/scripts:$EMACSD/pen.el/scripts
export PATH=$PATH:$EMACSD/host/pen.el/scripts/container:$EMACSD/pen.el/scripts/container
export PATH="$PATH:/root/go/bin"
export PATH="$PATH:/root/.cargo/bin/cargo"

if ! test -n "$PEN_DAEMON"; then
    . ~/.cargo/env
fi

# for ttyd
export LD_LIBRARY_PATH=/root/libwebsockets/build/lib:$LD_LIBRARY_PATH

[ -f "/root/.ghcup/env" ] && source "/root/.ghcup/env" # ghcup-env