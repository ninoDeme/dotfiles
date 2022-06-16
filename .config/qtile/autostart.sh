#!/bin/sh
picom --experimental-backends &
numlockx on &
nm-applet &
volumeicon &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg) &
nitrogen --restore &
flatpak run com.discordapp.Discord --start-minimized &