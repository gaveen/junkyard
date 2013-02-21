#!/bin/bash
#
# irsee - a simple wrapper to launch irssi with notification (my_desk)
#
#       NOTIFIER_PATH   - path to directory with NOTIFIER_NAME script
#       NOTIFIER_NAME   - name of the notifier script
#

NOTIFIER_PATH='~/.bin'
NOTIFIER_NAME='notify-listener'
NOTIFIER="$NOTIFIER_PATH/$NOTIFIER_NAME"

if [ "$(pgrep -u $EUID $NOTIFIER_NAME)" ]
then
    kill -9 $(pgrep -u $EUID $NOTIFIER_NAME)
fi

exec $NOTIFIER &
irssi
kill -9 $(pgrep -u $EUID $NOTIFIER_NAME)
