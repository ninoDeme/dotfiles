#! /bin/sh

chosen=$(printf "  Power Off\n  Restart\n  Lock\n Suspend" | rofi -dmenu -i -p ":")

case "$chosen" in
	"  Power Off") poweroff ;;
	"  Restart") reboot ;;
	"  Lock") i3lock-fancy ;;
	" Suspend") systemctl suspend;;
	*) exit 1 ;;
esac
