#! /bin/bash

set -e
[ -z "$DEFAULTTERM" ] && DEFAULTTERM="alacritty" #Set default terminal

# Chose editor
chosen=$(printf "Emacs\nEmacs Client\nVSCode\nNeovim\nTerminal" | rofi -dmenu -i -p "Editor:")

case "$chosen" in
    "Emacs Client") edit="emacsclient -c -a=''" ;;
    "Emacs") edit="emacs" ;;
    "VSCode") edit="code" ;;
    "Neovim") [ -t 1 ] && edit="nvim" || edit="$DEFAULTTERM -e nvim" ;;
    "Terminal") edit="$DEFAULTTERM" ;;
    *) exit 1 ;;
esac

# Set project list in format "<name that will appear on rofi>,<work dir>,<main file or use dot to use work dir>"
projects=("qtile,$HOME/.config/qtile,config.py" "AwesomeWM,$HOME/.config/awesome,rc.lua" "XMonad,$HOME/.config/xmonad,xmonad.hs" "Rofi,$HOME/.config/rofi,config.rasi" "Neovim,$HOME/.config/nvim,init.lua" "scripts,$HOME/scripts,." "Emacs,$HOME/.emacs.d,init.el" "Fish\x20Shell,$HOME/.config/fish,config.fish" "Bash,$HOME,.bashrc" "i3,$HOME/.config/i3/,config")

# Generate project prompt
rofi_prompt="Default"
for i in ${!projects[@]}
do tmpArray=(${projects[$i]//,/ })
	rofi_prompt="${rofi_prompt}\n$(($i + 1)): ${tmpArray[0]}"
done

# Run rofi prompt
exec_cmd=$(printf "$rofi_prompt" | rofi -dmenu -i -p "Project:")

# if Default is chosen, just open edit
if [ "$exec_cmd" == "Default" ]; then
	$edit
elif [ "$exec_cmd" == "" ]; then
    exit 1
else
	# Run project in editor chosen in prompt 
	projectIndex=(${exec_cmd//: / })
	tmpVar=${projectIndex[0]}
	tmpArray=(${projects[$(($tmpVar - 1))]//,/ })

	case "$chosen" in 
		"VSCode") cd ${tmpArray[1]} && $edit ${tmpArray[2]} . ;;
		"Terminal") $edit -d ${tmpArray[1]} ;;
		*) cd ${tmpArray[1]} && $edit ${tmpArray[2]} ;;
	esac
fi
