---------------------------
-- Default awesome theme --
---------------------------

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

theme.font = "NotoSans Nerd Font 10"
theme.font_mono = "NotoMono Nerd Font 10"

theme.bg_normal   = "#383c4a"
theme.dir         = os.getenv("HOME") .. "/.config/awesome/theme.lua"
theme.bg_focus    = "#5294e2"
theme.bg_urgent   = "#ff0000"
theme.bg_minimize = "#4b5162"
theme.bg_systray  = theme.bg_normal

theme.fg_normal   = "#aaaaaa"
theme.fg_focus    = "#eeeeee"
theme.fg_urgent   = "#ffffff"
theme.fg_minimize = "#eeeeee"
theme.fg_icon = "#78A4FF"

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
-- There are other variable sets
-- overriding the default one when
-- {{{ Menu
-- Create a launcher widget and a main menu

-- defined, the sets are:
-- taglist_[bg|fg]_[focus|urgent|occupied|empty|volatile]
-- tasklist_[bg|fg]_[focus|urgent]
-- titlebar_[bg|fg]_[normal|focus]
-- tooltip_[font|opacity|fg_color|bg_color|border_width|border_color]
-- mouse_finder_[color|timeout|animate_timeout|radius|factor]
-- prompt_[fg|bg|fg_cursor|bg_cursor|font]
-- hotkeys_[bg|fg|border_width|border_color|shape|opacity|modifiers_fg|label_bg|label_fg|group_margin|font|description_font]
-- Example:
--theme.taglist_bg_focus = "#ff0000"

-- Separators
local separatorempty = wibox.widget.textbox(" ")
local separatorbar = wibox.widget.textbox("|")
separatorbar = wibox.container.margin(separatorbar,1,1,0,2)
--separatorbar = wibox.widget.textbox("")

local mysystray = wibox.widget.systray()
mysystray.base_size = 19
mysystray = wibox.container.margin(mysystray,0,1,1,0)

local mykeyboardlayout = awful.widget.keyboardlayout()

-- Create a textclock widget
local clockicon = wibox.widget{
    markup = markup.fg.color(theme.fg_icon ," "),
    font = "NotoSans Nerd Font 11.5 ",
    widget = wibox.widget.textbox
}
local dateicon = wibox.widget{
    markup = markup.fg.color(theme.fg_icon ," "),
    font = "NotoSans Nerd Font 10 ",
    widget = wibox.widget.textbox
}
local myclock = wibox.widget {
    font = theme.font,
    format = "%H:%M ",
    widget = wibox.widget.textclock
}
local mydate = wibox.widget {
    font = theme.font,
    format = " %A, %d de %B de %Y ",
    widget = wibox.widget.textclock
}
local clock =  wibox.layout.fixed.horizontal(dateicon , mydate, separatorbar , clockicon, myclock)
local containerclock = wibox.container.background(clock)
containerclock.fg = theme.fg_focus
theme.cal = lain.widget.cal({
    attach_to = { containerclock },
    notification_preset = {
        shape = gears.shape.infobubble,
        fg   = theme.fg_focus,
        bg   = nconf.defaults.bg,
        font = theme.font_mono,
        margin = dpi(20),
        icon_size = 128
    },

    week_start = 1,

})

local mprisw = require("mpris-awesome")

-- ALSA volume

local volicon = wibox.widget{
    text = "墳",
    font = "NotoSans Nerd Font 14.5 ",
    widget = wibox.widget.textbox
}
local voliconcontainer = wibox.container.background(volicon)
voliconcontainer.fg = theme.fg_icon

theme.volume = lain.widget.alsabar {
    width = dpi(62), border_width = 0, ticks = true, ticks_size = dpi(6),
    notification_preset = { font = theme.font, bg = theme.bg_focus },
    --togglechannel = "IEC958,3",
    timeout = 0.5,
    settings = function()
        if volume_now.status == "off" then
            volicon:set_text("ﱝ")
        elseif volume_now.level == 0 then
            volicon:set_text("奄")
        elseif volume_now.level <= 50 then
            volicon:set_text("奔")
        else
            volicon:set_text("墳")
        end
    end,
    colors = {
        background   = theme.bg_normal,
        mute         = "#db1b0d",
        unmute       = theme.fg_focus
    }
}
theme.volume.tooltip.wibox.fg = "#000000"
theme.volume.tooltip.wibox.bg = "#000000"

volicon:buttons(my_table.join (
          awful.button({}, 1, function()
            awful.spawn("pavucontrol")
          end),
          awful.button({}, 2, function()
            os.execute(string.format("%s set %s 100%%", theme.volume.cmd, theme.volume.channel))
            theme.volume.update()
          end),
          awful.button({}, 3, function()
            os.execute(string.format("%s set %s toggle", theme.volume.cmd, theme.volume.togglechannel or theme.volume.channel))
            theme.volume.update()
          end),
          awful.button({}, 4, function()
            os.execute(string.format("%s set %s 1%%+", theme.volume.cmd, theme.volume.channel))
            theme.volume.update()
          end),
          awful.button({}, 5, function()
            os.execute(string.format("%s set %s 1%%-", theme.volume.cmd, theme.volume.channel))
            theme.volume.update()
          end)
))
theme.volume.bar:buttons(my_table.join (
          awful.button({}, 1, function()
            awful.spawn("pavucontrol")
          end),
          awful.button({}, 2, function()
            os.execute(string.format("%s set %s 100%%", theme.volume.cmd, theme.volume.channel))
            theme.volume.update()
          end),
          awful.button({}, 3, function()
            os.execute(string.format("%s set %s toggle", theme.volume.cmd, theme.volume.togglechannel or theme.volume.channel))
            theme.volume.update()
          end),
          awful.button({}, 4, function()
            os.execute(string.format("%s set %s 1%%+", theme.volume.cmd, theme.volume.channel))
            theme.volume.update()
          end),
          awful.button({}, 5, function()
            os.execute(string.format("%s set %s 1%%-", theme.volume.cmd, theme.volume.channel))
            theme.volume.update()
          end)
))

local volumebg = wibox.container.background(theme.volume.bar, theme.fg_focus, gears.shape.rectangle)
local volumewidget = wibox.container.margin(volumebg, dpi(2), dpi(5), dpi(4), dpi(4))

-- {{{ Wibar
-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal(
                "request::activate",
                "tasklist",
                { raise = true }
            )
        end
    end),
    awful.button({}, 3, function()
        awful.menu.client_list({ theme = { width = 250 } })
    end),
    awful.button({}, 4, function()
        awful.client.focus.byidx(1)
    end),
    awful.button({}, 5, function()
        awful.client.focus.byidx(-1)
    end))


function theme.at_screen_connect(s)
    -- Wallpaper
    local wallpaper = theme.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)


    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "", "ﭮ" }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()
    -- Create an imagebox widget which will contain an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox = wibox.container.margin(s.mylayoutbox, 2, 2,2,2)
    s.mylayoutbox:buttons(gears.table.join(
        awful.button({}, 1, function() awful.layout.inc(1) end),
        awful.button({}, 2, function () awful.layout.set( awful.layout.layouts[1] ) end),
        awful.button({}, 3, function() awful.layout.inc(-1) end),
        awful.button({}, 4, function() awful.layout.inc(1) end),
        awful.button({}, 5, function() awful.layout.inc(-1) end)))
    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons,
        layout = {
            spacing_widget = {
                {
                    thickness     = 0,
                    color         = theme.fg_normal,
                    widget        = wibox.widget.separator
                },
                valign = 'center',
                halign = 'center',
                widget = wibox.container.place,
            },
            spacing = 2,
            layout  = wibox.layout.fixed.horizontal
        },
        widget_template = {
            {
                
                {
                    {
                        {
                            id = 'icon_role',
                            widget = wibox.widget.imagebox
                        },
                        margins = 3.2,
                        widget = wibox.container.margin
                    },
                        {   
                            id     = 'text_role',
                            widget = wibox.widget.textbox,
                        },
                    layout = wibox.layout.fixed.horizontal,
                },
                left  = 1,
                right = 10,
                widget = wibox.container.margin
            },
            id     = 'background_role',
            widget = wibox.container.background,
        }
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", screen = s, height= 22 })

    -- Add widgets to the wibox
    s.mywibox:setup {
        layout = wibox.layout.align.horizontal,
        { -- Left widgets
            layout = wibox.layout.fixed.horizontal,
--            mylauncher,
            s.mytaglist,
            separatorbar,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            mprisw(),
            separatorbar,
            voliconcontainer,
            volumewidget,
--            mykeyboardlayout,
            separatorbar,
            mysystray,
            separatorbar,
            containerclock,
            separatorbar,
            s.mylayoutbox,
        },
    }
end



-- Generate taglist squares:
-- local taglist_square_size = dpi(4)
-- theme.taglist_squares_sel = theme_assets.taglist_squares_sel(
--     taglist_square_size, theme.fg_normal
-- )
-- theme.taglist_squares_unsel = theme_assets.taglist_squares_unsel(
--     taglist_square_size, theme.fg_normal
-- )

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

-- Define the image to load
theme.titlebar_close_button_normal = themes_path .. "default/titlebar/close_normal.png"
theme.titlebar_close_button_focus  = themes_path .. "default/titlebar/close_focus.png"

theme.titlebar_minimize_button_normal = themes_path .. "default/titlebar/minimize_normal.png"
theme.titlebar_minimize_button_focus  = themes_path .. "default/titlebar/minimize_focus.png"

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

theme.titlebar_maximized_button_normal_inactive = themes_path .. "default/titlebar/maximized_normal_inactive.png"
theme.titlebar_maximized_button_focus_inactive  = themes_path .. "default/titlebar/maximized_focus_inactive.png"
theme.titlebar_maximized_button_normal_active   = themes_path .. "default/titlebar/maximized_normal_active.png"
theme.titlebar_maximized_button_focus_active    = themes_path .. "default/titlebar/maximized_focus_active.png"

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

-- Define the icon theme for application icons. If not set then the icons
-- from /usr/share/icons and /usr/share/icons/hicolor will be used.
theme.icon_theme = "/usr/share/icons/Arc/"
return theme

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80
