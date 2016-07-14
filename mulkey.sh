#!/usr/bin/bash
#
# mulkey - a simple wrapper for media player functions (my_desk)
#
# To define a new player use the following syntax:
#       PLAYER_PREF[<id>]="<program> <--previous> <--toggle> <--next>"
#
#       Where:
#           <id>            = ID to refer the player
#           <program>       = Command to issue player actions
#           <--previous>    = <program> Option to play previous track
#           <--toggle>      = <program> Option to play/pause toggle
#           <--next>        = <program> Option to play next track
#
#       e.g.,:
#       PLAYER_PREF[1]="mocp --previous --toggle-pause --next"
#
# Useful when binding actions to multimedia keys
#

ARGS=1
E_BADARGS=65
E_NOFILE=66
E_NOPROG=67

if [ ! $# == $ARGS ] ; then
    echo "Usage: `basename $0`  [ --prev | --toggle | --next ]"
    exit $E_BADARGS
fi

# Define players and actions
declare -A PLAYER_PREF
PLAYER_PREF[0]="audacious --rew --play-pause --fwd"
PLAYER_PREF[1]="mocp --previous --toggle-pause --next"
PLAYER_PREF[2]="rhythmbox-client --previous --play-pause --next"

# Do the action only for specified players
for i in 0 1 2
do
    PLAYER=$(echo ${PLAYER_PREF[$i]} | cut -f1 -d " ")
    ACT_PREV=$(echo ${PLAYER_PREF[$i]} | cut -f2 -d " ")
    ACT_TOGL=$(echo ${PLAYER_PREF[$i]} | cut -f3 -d " ")
    ACT_NEXT=$(echo ${PLAYER_PREF[$i]} | cut -f4 -d " ")

    if pgrep -c $PLAYER
    then
        case $1 in
            --prev)
                $PLAYER $ACT_PREV
                ;;
            --togl)
                $PLAYER $ACT_TOGL
                ;;
            --next)
                $PLAYER $ACT_NEXT
                ;;
            *)
                echo "Usage: `basename $0`  [ --prev | --togl | --next ]"
                exit $E_BADARGS
                ;;
        esac
    else
        echo "Error: $PLAYER is not running"
        exit $E_NOPROG
    fi
done
