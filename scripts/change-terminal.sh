#! /bin/bash

chosen=$(printf "Alacritty\nKitty" | rofi -dmenu -i -p "Terminal:")

case "$chosen" in
	"Alacritty") echo "alacritty" > $HOME/.config/DefaultTerm ;;
	"Kitty") echo "kitty" > $HOME/.config/DefaultTerm ;;
	*) exit 1 ;;
esac
