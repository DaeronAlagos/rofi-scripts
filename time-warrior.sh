#!/usr/bin/env bash

COMMANDS=(
    "Start\0icon\x1fstart\n"
    "Stop\0icon\x1fstop\n"
    "Continue\0icon\x1fforward\n"
    "Track\0icon\x1fclock\n"
    "Cancel\0icon\x1fcancel\n"
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
        echo -e $command
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
    # Read the timew summary output line by line
    while IFS= read -r line; do
        # Skip the header line and empty lines
        if [[ $line =~ ^Wk|^$|^[[:space:]]*$ ]]; then
            continue
        fi
        
        # Extract the ID and tags using awk
        if [[ $line =~ @[0-9]+ ]]; then
            id=$(echo "$line" | awk '{for(i=1;i<=NF;i++) if($i ~ /@[0-9]+/) print $i}' | sed 's/@//')
            # Get everything after the ID until the time
            tags=$(echo "$line" | awk -F '@[0-9]+ ' '{print $2}' | awk '{$NF=""; $(NF-1)=""; $(NF-2)=""; print $0}' | sed 's/[[:space:]]*$//')
            # Format output for rofi
            echo -e "${tags}\0info\x1f@${id}"
        fi
    done < <(timew summary :ids :week)
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
        echo -en "\x00prompt\x1fID: \n"
        echo -en "\0message\x1f<b>Quit</b> to exit\n"
        _intervals
        echo -en "Quit\0icon\x1fexit\n"
    elif [[ "$PREVIOUS" = "Continue" ]]; then
        timew continue "@$@"
    else
        timew start "$@" >/dev/null
        exit 0
    fi
    PREVIOUS="$@"
fi