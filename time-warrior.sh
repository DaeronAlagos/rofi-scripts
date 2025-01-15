#!/usr/bin/env bash

COMMANDS=(
    "Start\0icon\x1fstart\n"
    "Stop\0icon\x1fstop\n"
    "Track\0icon\x1fclock\n"
    "Cancel\0icon\x1fcancel\n"
    "Continue\0icon\x1fforward\n"
    # ["Undo"]="undo"
    # ["Join"]="join"
    # ["Split"]="split"
    # ["Modify"]="modify"
    # ["Resize"]="resize"
    # ["Shorten"]="shorten"
    # ["Lengthen"]="lengthen"
    # ["Move"]="move"
    # ["Delete"]="delete"
    # ["Cancel"]="cancel"
    # ["Track"]="track"
    # ["Stop"]="stop"
    # ["Start"]="start"
)

list_commands() {
    echo -en "\0message\x1f<b>Quit</b> to exit\n"
    for command in ${COMMANDS[@]}
    do
        echo $command
    done
    echo -en "Quit\0icon\x1fexit\n"
}

_tags() {
    TAGS=($(timew tags :week))
    S_TAGS=${TAGS[@]:4}
    C_TAGS=()
    NEW_TAGS=()
    for tag in ${S_TAGS[@]}
    do
        if [[ "$tag" != "-" ]]; then
            C_TAGS+=($tag)
        else
            echo "${C_TAGS[@]}"
            unset C_TAGS
        fi
    done
}

_intervals() {
    INTERVALS=$(timew summary :ids :week)
    declare -A ITEMS
    declare -- IDX
    for i in ${INTERVALS[@]}
    do
        if [[ $i =~ @[0-9] ]]; then
            IDX="${i}"
        elif [[ -n $IDX ]]; then
            ITEMS[$i]="$IDX"
            unset IDX
        fi
    done
    for int in ${!ITEMS[@]}
    do
        echo $int
    done
}

# Check if data file exists. Create it if not.
if [[ ! -f $HOME/.config/rofi/time-warrior.dat ]]; then
    touch $HOME/.config/rofi/time-warrior.dat
fi

declare -A CONF

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
    elif [[ "$@" = "Continue" ]]; then
        _intervals
    else
        timew start "$@" >/dev/null
        exit 0
    fi
fi