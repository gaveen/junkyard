#!/usr/bin/bash
#
# mulkey - a simple wrapper for media player functions (my_desk)
#
#       PLAYER      - player command name
#       ACT_PREV    - player action: previous
#       ACT_NEXT    - player action: next
#       ACT_TOGL    - player action: toggle pause/resume
#
# Useful when binding actions to multimedia keys
# Inspired by: https://gist.github.com/chanux/db01bd2c66effc7a259f
#

ARGS=1
E_BADARGS=65
E_NOFILE=66
E_NOPROG=67

PLAYER="mocp"
ACT_PREV="--previous"
ACT_NEXT="--next"
ACT_TOGL="--toggle-pause"

if [ ! $# == $ARGS ] ; then
    echo "Usage: `basename $0`  [ --prev | --toggle | --next ]"
    exit $E_BADARGS
fi

if pgrep -c $PLAYER
then
    case $1 in
        --next)
            $PLAYER $ACT_NEXT
            ;;
        --prev)
            $PLAYER $ACT_PREV
            ;;
        --toggle)
            $PLAYER $ACT_TOGL
            ;;
        *)
            echo "Usage: `basename $0`  [ --prev | --toggle | --next ]"
            exit $E_BADARGS
            ;;
    esac
else
    echo "Error: $PLAYER is not running"
    exit $E_NOPROG
fi
