#!/usr/bin/bash
#
# mulkey - a simple wrapper for media player functions (my_desk)
#
# To define a new player use the following syntax (space delimited):
#       PLAYER_DEF[<id>]="<program> <--previous> <--toggle> <--next>"
#
#       Where:
#           <id>            = ID to refer the player
#           <program>       = Command to issue player actions
#           <--previous>    = <program> Option to play previous track
#           <--toggle>      = <program> Option to play/pause toggle
#           <--next>        = <program> Option to play next track
#
#       e.g.,:
#       PLAYER_DEF[1]="mocp --previous --toggle-pause --next"
#
# Useful when binding actions to multimedia keys
#

ARGS=1
E_BADARGS=65
E_NOFILE=66
E_NOPROG=67

if [ ! $# == $ARGS ] ; then
    echo "Usage: `basename $0`  [ --prev | --togl | --next ]"
    exit $E_BADARGS
fi

# Define players and actions
declare -A PLAYER_DEF
PLAYER_DEF[audacious]="audacious --rew --play-pause --fwd"
PLAYER_DEF[moc]="mocp --previous --toggle-pause --next"
PLAYER_DEF[rhythmbox]="rhythmbox-client --previous --play-pause --next"

# Do the action only for specified players
for i in audacious moc rhythmbox
do
    PLAY_CLI=$(echo ${PLAYER_DEF[$i]} | cut -f1 -d " ")
    ACT_PREV=$(echo ${PLAYER_DEF[$i]} | cut -f2 -d " ")
    ACT_TOGL=$(echo ${PLAYER_DEF[$i]} | cut -f3 -d " ")
    ACT_NEXT=$(echo ${PLAYER_DEF[$i]} | cut -f4 -d " ")

    if pgrep -c $PLAY_CLI
    then
        case $1 in
            --prev)
                $PLAY_CLI $ACT_PREV
                ;;
            --togl)
                $PLAY_CLI $ACT_TOGL
                ;;
            --next)
                $PLAY_CLI $ACT_NEXT
                ;;
            *)
                echo "Usage: `basename $0`  [ --prev | --togl | --next ]"
                exit $E_BADARGS
                ;;
        esac
    else
        echo "Error: $PLAY_CLI is not running"
        exit $E_NOPROG
    fi
done
