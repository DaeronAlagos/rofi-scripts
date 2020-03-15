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

_tags() {
    TAGS=($(timew tags :week))
    S_TAGS=${TAGS[@]:4}
    NEW_TAGS=( ${S_TAGS[@]//-/} )
    for tag in ${NEW_TAGS[@]}
    do
        echo $tag
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
        _tags
        echo -en "Quit\0icon\x1fexit\n"

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