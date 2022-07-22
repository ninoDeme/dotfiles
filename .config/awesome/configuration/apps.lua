local filesystem = require('gears.filesystem')

-- Thanks to jo148 on github for making rofi dpi aware!
-- local with_dpi = require('beautiful').xresources.apply_dpi
-- local get_dpi = require('beautiful').xresources.get_dpi

return {
  -- List of apps to start by default on some actions
  default = {
    terminal = 'alacritty',
    lock = 'i3lock-fancy',
    quake = 'kitty',
    screenshot = 'flameshot screen -p ~/Pictures',
    region_screenshot = 'flameshot gui -p ~/Pictures',
    delayed_screenshot = 'flameshot screen -p ~/Pictures -d 5000',
    browser = 'qutebrowser',
    editor = 'emacsclient -c -a=""', -- gui text editor
    termeditor = 'nvim', -- gui text editor
    -- discord = 'flatpak run com.discordapp.Discord',
    discord = 'chromium --profile-directory=Default --app-id=nebbmpibgobljecgkdipmcfonkkmcggn',
    -- discord = 'qutebrowser --target "window" -s "window.title_format" "{current_title}{title_sep}Discord" discord.com/app',
    files = 'thunar',
    termfiles = 'ranger',
  },
  -- List of apps to start once on start-up
  run_on_start_up = {
    'picom --experimental-backends --config ' .. filesystem.get_configuration_dir() .. '/configuration/picom.conf',
--    'pnmixer', -- shows an audiocontrol applet in systray when installed.
    'numlockx on', -- enable numlock
    'nm-applet --indicator',
    'setxkbmap  -option ctrl:nocaps',
    '/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 & eval $(gnome-keyring-daemon -s --components=pkcs11,secrets,ssh,gpg)', -- credential manager
    'xfce4-power-manager', -- Power manager
    'flameshot',
    'steam -silent',
  }
}
