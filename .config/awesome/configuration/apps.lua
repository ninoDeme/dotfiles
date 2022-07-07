local filesystem = require('gears.filesystem')

-- Thanks to jo148 on github for making rofi dpi aware!
local with_dpi = require('beautiful').xresources.apply_dpi
local get_dpi = require('beautiful').xresources.get_dpi
--local rofi_command = 'env /usr/bin/rofi -dpi ' .. get_dpi() .. ' -width ' .. with_dpi(400) .. ' -show drun -theme ' .. filesystem.get_configuration_dir() .. '/configuration/rofi.rasi -run-command "/bin/bash -c -i \'shopt -s expand_aliases; {cmd}\'"'

return {
  -- List of apps to start by default on some actions
  default = {
    terminal = 'alacritty',
--    rofi = rofi_command,
    lock = 'i3lock-fancy',
    quake = 'kitty',
    screenshot = 'flameshot screen -p ~/Pictures',
    region_screenshot = 'flameshot gui -p ~/Pictures',
    delayed_screenshot = 'flameshot screen -p ~/Pictures -d 5000',
    browser = 'firefox',
    editor = 'emacs', -- gui text editor
    termeditor = 'nvim', -- gui text editor
    -- discord = 'flatpak run com.discordapp.Discord',
    discord = 'chromium --profile-directory=Default --app-id=nebbmpibgobljecgkdipmcfonkkmcggn',
--    game = rofi_command,
    files = 'thunar',
--    music = rofi_command 
  },
  -- List of apps to start once on start-up
  run_on_start_up = {
    'picom --experimental-backends --config ' .. filesystem.get_configuration_dir() .. '/configuration/picom.conf',
--    'nm-applet --indicator', -- wifi
--    'pnmixer', -- shows an audiocontrol applet in systray when installed.
    --'blueberry-tray', -- Bluetooth tray icon
    'numlockx on', -- enable numlock
    'nm-applet --indicator',
    '/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)', -- credential manager
    'xfce4-power-manager', -- Power manager
    'flameshot',
    -- 'kdeconnect-indicator',
    'steam -silent',
  }
}
