#!/usr/bin/env bash

list_commands() {
    echo "start"
    echo "stop"
}

COMMAND=

if [[ -z "$@" ]]; then
    list_commands
else
    if [[ "$@" = "start" ]]; then
        echo -en "\x00prompt\x1fEnter Tag: \n"
        echo -en "\0message\x1f<b>Quit</b> to exit\n"
        echo "quit"
        TASK=$(echo )
    elif [[ "$@" = "stop" ]]; then
        timew stop >/dev/null
        exit 0
    else
        timew start "$@" >/dev/null
        exit 0
    fi
fi