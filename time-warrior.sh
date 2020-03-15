#!/usr/bin/env bash

list_commands() {
    echo "start"
    echo "stop"
    # echo "track"
    echo "cancel"
    # echo "continue"
    # echo "delete"
    # echo "move"
    # echo "lengthen"
    # echo "shorten"
    # echo "resize"
    # echo "modify"
    # echo "split"
    # echo "join"
    # echo "undo"
}

if [[ -z "$@" ]]; then
    list_commands
else
    if [[ "$@" = "quit" ]]; then
        exit 0
    elif [[ "$@" = "start" ]]; then
        echo -en "\x00prompt\x1fEnter Tag: \n"
        echo -en "\0message\x1f<b>Quit</b> to exit\n"
        echo "quit"
        TASK=$(echo )
    elif [[ "$@" = "stop" ]]; then
        timew stop >/dev/null
        exit 0
    elif [[ "$@" = "cancel" ]]; then
        timew cancel >/dev/null
    else
        timew start "$@" >/dev/null
        exit 0
    fi
fi