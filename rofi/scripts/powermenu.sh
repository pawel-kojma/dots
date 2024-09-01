#!/usr/bin/env bash

SHUTDOWN="󰐥"
LOGOUT="󰍃"
LOCK="󰌾"
REBOOT="󰜉"

if [[ -z "$@" ]] then
	echo $SHUTDOWN
	echo $LOGOUT
	echo $LOCK
	echo $REBOOT
	exit 0
fi

case "$@" in
	$SHUTDOWN)
	systemctl poweroff
	;;
	$LOGOUT)
	echo "Not implemented"
	exit 1
	;;
	$LOCK)
	loginctl lock-session
	;;
	$REBOOT)
	systemctl reboot
	;;
	*)
	echo "Unknown option '$@'"
	exit 1
	;;
esac
