#!/bin/bash

{
stty stop undef; stty start undef
} 2>/dev/null

# Debian10 run Pen

# export PEN_DEBUG=y

export LANG=en_US
export LANGUAGE=en_US:en
export LC_ALL=en_US.UTF-8

: "${SOCKET:="DEFAULT"}"

while [ $# -gt 0 ]; do opt="$1"; case "$opt" in
    "") { shift; }; ;;
    -D) {
        SOCKET="$2"
        shift
        shift
    }
    ;;

    --parallel|--pool) {
        export USE_POOL=y
        shift
    }
    ;;

    *) break;
esac; done

export EMACSD=/root/.emacs.d
export YAMLMOD_PATH=$EMACSD/emacs-yamlmod
export PATH=$PATH:$EMACSD/host/pen.el/scripts:$EMACSD/pen.el/scripts

last_arg="${@: -1}"
last_arg="$(p "$last_arg" | pen-bs '\\')"

shopt -s nullglob
if test "$USE_POOL" = "y"; then
    # ugh... using sentinals is a pain. Just select one.
    # Just take the first one
    SOCKET="$(basename "$(shopt -s nullglob; cd $HOME/.pen/pool/available; ls pen-emacsd-* | shuf -n 1)")"
    # for socket_fp in ~/.pen/pool/available/pen-emacsd-*; do
    #     SOCKET="$(basename "$socket_fp")"
    #     echo "$SOCKET" >> /tmp/d.txt
    #     break
    # done

    test -z "$SOCKET" && exit 1
    rm -f ~/.pen/pool/available/$SOCKET
fi

fp="/tmp/eval-output-${SOCKET}.txt"
rm -f "$fp"
# Can't use cmd because elisp doesn't use single quote for strings
cmd1 unbuffer emacsclient -a "" -s ~/.emacs.d/server/$SOCKET -e "(pen-eval-for-host \"$SOCKET\" $last_arg)" >> /tmp/lsp.log
unbuffer emacsclient -a "" -s ~/.emacs.d/server/$SOCKET -e "(pen-eval-for-host \"$SOCKET\" $last_arg)" &>/dev/null
sleep 0.1

if test "$USE_POOL" = "y"; then
    touch ~/.pen/pool/available/$SOCKET
fi

# I need to hide the fact that it failed. Otherwise, I can't cancel comint commands without polluting the repl
cat "$fp" 2>/dev/null
