#!/usr/bin/env bash

SHUTDOWN="O"
LOGOUT="O"
LOCK="L"
REBOOT="R"

CHOICE=$(echo "$SHUTDOWN
$LOGOUT
$LOCK
$REBOOT" | rofi -dmenu -theme $XDG_CONFIG_HOME/rofi/powermenu.rasi)

case $CHOICE in
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
