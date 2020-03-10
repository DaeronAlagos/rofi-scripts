#!/usr/bin/env bash

if [ "$@" = "quit" ]
then
    exit 0
fi

if [[ "$@" = "start" ]]; then
    # Override the previously set prompt.
    echo -en "\x00prompt\x1fChange prompt\n"
    query=$( (echo ) | rofi  -dmenu -p "Tag > " )
    if [ -n "$query "]
    then
    	timew start "$query"
    	echo "quit"
    fi
elif [[ "$@" = "stop" ]]; then
	timew stop
else
    echo -en "\x00prompt\x1fTimeWarrior\n"
    echo -en "\0urgent\x1f0,2\n"
    echo -en "\0active\x1f1\n"
    echo -en "\0markup-rows\x1ftrue\n"
    echo -en "\0message\x1fCommands\n"

    echo "start"
    echo "stop"
    echo "modify"
    echo "quit"
fi