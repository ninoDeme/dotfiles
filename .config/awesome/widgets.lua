local beautiful = require("beautiful")
local lain = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local naughty = require("naughty")
local nconf = naughty.config
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility


local xresources = require("beautiful.xresources")

local dpi = xresources.apply_dpi

local markup = lain.util.markup


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
    markup = markup.fg.color(beautiful.fg_icon ," "),
    font = beautiful.nosfont .."11.5 ",
    widget = wibox.widget.textbox
}
local dateicon = wibox.widget{
    markup = markup.fg.color(beautiful.fg_icon ," "),
    font = beautiful.nosfont .."10 ",
    widget = wibox.widget.textbox
}
local myclock = wibox.widget {
    font = beautiful.font,
    format = "%H:%M ",
    widget = wibox.widget.textclock
}
local mydate = wibox.widget {
    font = beautiful.font,
    format = " %A, %d de %B de %Y ",
    widget = wibox.widget.textclock
}
local clock =  wibox.layout.fixed.horizontal(clockicon, myclock)
local containerclock = wibox.container.background(clock)
containerclock.fg = beautiful.fg_focus
local date =  wibox.layout.fixed.horizontal(dateicon , mydate)
local containerdate = wibox.container.background(date)
containerdate.fg = beautiful.fg_focus

local cal = lain.widget.cal({
    attach_to = { containerdate },
    notification_preset = {
        shape = gears.shape.infobubble,
        fg   = beautiful.fg_focus,
        bg   = nconf.defaults.bg,
        font = beautiful.font_mono,
        margin = dpi(20),
        icon_size = 128
    },

    week_start = 1,

})


-- ALSA volume

local volicon = wibox.widget{
    text = "墳",
    font = beautiful.nosfont .."14.5 ",
    widget = wibox.widget.textbox
}
local voliconcontainer = wibox.container.background(volicon)
voliconcontainer.fg = beautiful.fg_icon

local volume = lain.widget.alsabar {
    width = dpi(62), border_width = 0, ticks = true, ticks_size = dpi(6),
    notification_preset = { font = beautiful.font, bg = beautiful.bg_focus },
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
        background   = beautiful.bg_normal,
        mute         = "#db1b0d",
        unmute       = beautiful.fg_focus
    }
}

volicon:buttons(my_table.join (
          awful.button({}, 1, function()
            awful.spawn("pavucontrol")
          end),
          awful.button({}, 2, function()
            os.execute(string.format("%s set %s 100%%", volume.cmd, volume.channel))
            volume.update()
          end),
          awful.button({}, 3, function()
            os.execute(string.format("%s set %s toggle", volume.cmd, volume.togglechannel or volume.channel))
            volume.update()
          end),
          awful.button({}, 4, function()
            os.execute(string.format("%s set %s 1%%+", volume.cmd, volume.channel))
            volume.update()
          end),
          awful.button({}, 5, function()
            os.execute(string.format("%s set %s 1%%-", volume.cmd, volume.channel))
            volume.update()
          end)
))
volume.bar:buttons(my_table.join (
          awful.button({}, 1, function()
            awful.spawn("pavucontrol", {properties = { floating = true}})
          end),
          awful.button({}, 2, function()
            os.execute(string.format("%s set %s 100%%", volume.cmd, volume.channel))
            volume.update()
          end),
          awful.button({}, 3, function()
            os.execute(string.format("%s set %s toggle", volume.cmd, volume.togglechannel or volume.channel))
            volume.update()
          end),
          awful.button({}, 4, function()
            os.execute(string.format("%s set %s 1%%+", volume.cmd, volume.channel))
            volume.update()
          end),
          awful.button({}, 5, function()
            os.execute(string.format("%s set %s 1%%-", volume.cmd, volume.channel))
            volume.update()
          end)
))

local volumebg = wibox.container.background(volume.bar, beautiful.fg_focus, gears.shape.rectangle)
local volumewidget = wibox.container.margin(volumebg, dpi(2), dpi(5), dpi(4), dpi(4))

return {
  volumewidget = volumewidget,
  volicon = voliconcontainer,
  mysystray = mysystray,
  separatorbar = separatorbar,
  separatorempty = separatorempty,
  mpris_widget = require("mpris-awesome"),
  clock = containerclock,
  date = containerdate
}