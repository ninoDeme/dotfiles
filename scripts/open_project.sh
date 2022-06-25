#! /bin/bash

# Chose editor
chosen=$(printf "Emacs\nVSCode\nNeovim" | rofi -dmenu -i -p "Editor:")

case "$chosen" in
    "Emacs") edit="emacs" ;;
    "VSCode") edit="code" ;;
    "Neovim") edit="kitty -e nvim" ;;
    *) exit 1 ;;
esac

# Set project list in format "<name that will appear on rofi>,<work dir>,<main file or use dot to use work dir>"
projects=("qtile,$HOME/.config/qtile,config.py" "AwesomeWM,$HOME/.config/awesome,rc.lua" "XMonad,$HOME/.config/xmonad,xmonad.hs" "Rofi,$HOME/.config/rofi,config.rasi" "Neovim,$HOME/.config/nvim,init.lua" "scripts,$HOME/scripts,." "Emacs,$HOME/.emacs.d,init.el" "Fish_Shell,$HOME/.config/fish,config.fish" "Bash,$HOME,.bashrc")

# Generate project prompt
rofi_prompt=""
for i in ${!projects[@]}
do tmpArray=(${projects[$i]//,/ })
	rofi_prompt="${rofi_prompt}\n$(($i + 1)): ${tmpArray[0]}"
done
rofi_prompt=${rofi_prompt:2} # Remove first \n

# Run rofi prompt
exec_cmd=$(printf "$rofi_prompt" | rofi -dmenu -i -p "Project:")

# Run project in editor chosen in prompt 
projectIndex=(${exec_cmd//: / })
tmpVar=${projectIndex[0]}
tmpArray=(${projects[$(($tmpVar - 1))]//,/ })
if [ "$edit" != "code " ]; then
	echo "cd ${tmpArray[1]} && $edit ${tmpArray[2]}"
	cd ${tmpArray[1]} && $edit ${tmpArray[2]}
else
	cd ${tmpArray[1]} && $edit ${tmpArray[2]} .
fi

