#!/usr/bin/env bash

COMMANDS=(
    "Start"
    "Stop"
    "Track"
    "Cancel"
    # ["Undo"]="undo"
    # ["Join"]="join"
    # ["Split"]="split"
    # ["Modify"]="modify"
    # ["Resize"]="resize"
    # ["Shorten"]="shorten"
    # ["Lengthen"]="lengthen"
    # ["Move"]="move"
    # ["Delete"]="delete"
    # ["Continue"]="continue"
    # ["Cancel"]="cancel"
    # ["Track"]="track"
    # ["Stop"]="stop"
    # ["Start"]="start"
)

list_commands() {
    for i in "${COMMANDS[@]}"
    do
        echo "$i"
    done
}

if [[ -z "$@" ]]; then
    list_commands
else
    if [[ "$@" = "Quit" ]]; then
        exit 0
    fi
    if [[ "$@" = "Start" ]]; then
        echo -en "\x00prompt\x1fTag: \n"
        echo -en "\0message\x1f<b>Quit</b> to exit\n"
        echo -en "Quit\0icon\x1fexit\n"
        # echo "Quit"
        TASK=$(echo )
    elif [[ "$@" = "Stop" ]]; then
        timew stop >/dev/null
        exit 0
    elif [[ "$@" = "Cancel" ]]; then
        timew cancel >/dev/null
    else
        timew start "$@" >/dev/null
        exit 0
    fi
fi