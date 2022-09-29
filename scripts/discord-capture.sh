#! /bin/env sh

chosen=$(pw-cli ls Node | grep -B1 --no-group-separator Stream/Output/Audio | sed '/media.class = "Stream\/Output\/Audio"/d ; s/\"//g ; s/node.name = //g' | awk '{$1=$1};1' | rofi -dmenu -i -p "Application:")

path=$(dirname -- "$0")
if [ "$chosen" != "" ]; then
	alacritty -e $path/virtmic-exec.sh "$chosen"
else
	exit 1
fi
