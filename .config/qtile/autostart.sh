#!/bin/sh
picom --experimental-backends &
numlockx on &
nm-applet &
volumeicon &
xfce4-power-manager &
flameshot &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg) &
#nitrogen --restore &
steam -silent &
flatpak run com.discordapp.Discord --start-minimized &