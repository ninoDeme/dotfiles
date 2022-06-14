

local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local lain = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

local gfs = require("gears.filesystem")
local themes_path = gfs.get_themes_dir()

local apps = require("configuration.apps")

local theme = {}
local nconf = naughty.config

local markup = lain.util.markup

theme.dir         = os.getenv("HOME") .. "/.config/awesome/theme.lua"

theme.font = "NotoSans Nerd Font 10"
theme.font_mono = "NotoMono Nerd Font 10"
theme.nosfont = "NotoSans Nerd Font "
theme.nosfont_mono = "NotoMono Nerd Font "

theme.bg_normal   = "#383c4a"
theme.bg_focus    = "#5294e2"
theme.bg_urgent   = "#ff0000"
theme.bg_minimize = "#4b5162"
theme.bg_systray  = theme.bg_normal

theme.fg_normal   = "#aaaaaa"
theme.fg_focus    = "#eeeeee"
theme.fg_urgent   = "#ffffff"
theme.fg_minimize = "#eeeeee"
theme.fg_icon = "#6894FF"
theme.hotkeys_modifiers_fg = theme.fg_focus

theme.useless_gap   = dpi(2)
theme.border_width  = dpi(2)
theme.border_normal = "#535d6c"
theme.border_focus  = "#5294e2"
theme.border_marked = "#91231c"

theme.tasklist_bg_focus = theme.bg_normal

theme.taglist_fg_occupied = theme.fg_minimize
theme.taglist_fg_empty = theme.fg_normal

theme.systray_icon_spacing = dpi(1)

nconf.defaults.icon_size = dpi(64)
nconf.defaults.bg = theme.bg_normal .. "80"

theme.gap_single_client = false

-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"=

-- Variables set for theming notifications:
-- notification_font
-- notification_[bg|fg]
-- notification_[width|height|margin]
-- notification_[border_color|border_width|shape|opacity]

-- Variables set for theming the menu:
-- menu_[bg|fg]_[normal|focus]
-- menu_[border_color|border_width]
theme.menu_fg_normal    = theme.fg_focus
theme.menu_submenu_icon = themes_path .. "default/submenu.png"
theme.menu_height       = dpi(15)
theme.menu_width        = dpi(100)

-- You can add as many variables as
-- you wish and access them by using
-- beautiful.variable in your rc.lua
--theme.bg_widget = "#cc0000"

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "/usr/share/icons/Arc/"

-- Define the image to load
theme.titlebar_close_button_normal = gears.color.recolor_image(theme.icon_theme .. "actions/symbolic/window-close-symbolic.svg", theme.fg_normal)
theme.titlebar_close_button_focus  = gears.color.recolor_image(theme.icon_theme .. "actions/symbolic/window-close-symbolic.svg", theme.fg_focus)

--theme.titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png"
--theme.titlebar_minimize_button_focus  = themes_path .. "default/titlebar/minimize_focus.png"
theme.titlebar_minimize_button_normal = gears.color.recolor_image(theme.icon_theme .. "actions/symbolic/window-minimize-symbolic.svg", theme.fg_normal)
theme.titlebar_minimize_button_focus  = gears.color.recolor_image(theme.icon_theme .. "actions/symbolic/window-minimize-symbolic.svg", theme.fg_focus)

theme.titlebar_ontop_button_normal_inactive = themes_path .. "default/titlebar/ontop_normal_inactive.png"
theme.titlebar_ontop_button_focus_inactive  = themes_path .. "default/titlebar/ontop_focus_inactive.png"
theme.titlebar_ontop_button_normal_active   = themes_path .. "default/titlebar/ontop_normal_active.png"
theme.titlebar_ontop_button_focus_active    = themes_path .. "default/titlebar/ontop_focus_active.png"

theme.titlebar_sticky_button_normal_inactive = themes_path .. "default/titlebar/sticky_normal_inactive.png"
theme.titlebar_sticky_button_focus_inactive  = themes_path .. "default/titlebar/sticky_focus_inactive.png"
theme.titlebar_sticky_button_normal_active   = themes_path .. "default/titlebar/sticky_normal_active.png"
theme.titlebar_sticky_button_focus_active    = themes_path .. "default/titlebar/sticky_focus_active.png"

theme.titlebar_floating_button_normal_inactive = themes_path .. "default/titlebar/floating_normal_inactive.png"
theme.titlebar_floating_button_focus_inactive  = themes_path .. "default/titlebar/floating_focus_inactive.png"
theme.titlebar_floating_button_normal_active   = themes_path .. "default/titlebar/floating_normal_active.png"
theme.titlebar_floating_button_focus_active    = themes_path .. "default/titlebar/floating_focus_active.png"

--theme.titlebar_maximized_button_normal_inactive = themes_path .. "default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_normal_inactive = gears.color.recolor_image(theme.icon_theme .. "actions/symbolic/window-maximize-symbolic.svg", theme.fg_normal)
theme.titlebar_maximized_button_focus_inactive  = gears.color.recolor_image(theme.icon_theme .. "actions/symbolic/window-maximize-symbolic.svg", theme.fg_focus)
--theme.titlebar_maximized_button_normal_active   = themes_path .. "default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_normal_active   = gears.color.recolor_image(theme.icon_theme .. "actions/symbolic/window-restore-symbolic.svg", theme.fg_normal)
theme.titlebar_maximized_button_focus_active    = gears.color.recolor_image(theme.icon_theme .. "actions/symbolic/window-restore-symbolic.svg", theme.fg_focus)

theme.wallpaper = "/usr/share/endeavouros/backgrounds/eos_wallpapers_community/Endy_vector_satelliet.png"

-- You can use your own layout icons like this:
theme.layout_fairh      = themes_path .. "default/layouts/fairhw.png"
theme.layout_fairv      = themes_path .. "default/layouts/fairvw.png"
theme.layout_floating   = themes_path .. "default/layouts/floatingw.png"
theme.layout_magnifier  = themes_path .. "default/layouts/magnifierw.png"
theme.layout_max        = themes_path .. "default/layouts/maxw.png"
theme.layout_fullscreen = themes_path .. "default/layouts/fullscreenw.png"
theme.layout_tilebottom = themes_path .. "default/layouts/tilebottomw.png"
theme.layout_tileleft   = themes_path .. "default/layouts/tileleftw.png"
theme.layout_tile       = themes_path .. "default/layouts/tilew.png"
theme.layout_tiletop    = themes_path .. "default/layouts/tiletopw.png"
theme.layout_spiral     = themes_path .. "default/layouts/spiralw.png"
theme.layout_dwindle    = themes_path .. "default/layouts/dwindlew.png"
theme.layout_cornernw   = themes_path .. "default/layouts/cornernww.png"
theme.layout_cornerne   = themes_path .. "default/layouts/cornernew.png"
theme.layout_cornersw   = themes_path .. "default/layouts/cornersww.png"
theme.layout_cornerse   = themes_path .. "default/layouts/cornersew.png"

-- Generate Awesome icon:
theme.awesome_icon = theme_assets.awesome_icon(
    theme.menu_height, theme.bg_normal, theme.fg_focus
)


return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
