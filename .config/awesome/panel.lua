local beautiful = require("beautiful")
local lain = require("lain")
local awful = require("awful")
local wibox = require("wibox")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
local gears = require("gears")
local naughty = require("naughty")
local clickable_container = require("clickable-container")

local widgets = require("widgets")

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
        if c.minimized == false then
            c.minimized = true
        else
            c.minimized = false
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

--client.connect_signal("property::name", function(c)
--    if string.len(c.name) > 60 then
--        c.name = string.sub(c.name, 0, 60) .. "..."
--    end
--end)


function beautiful.at_screen_connect(s)

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
        buttons = taglist_buttons,
        layout = {
            layout = wibox.layout.fixed.horizontal
        },
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
                    color         = beautiful.fg_normal,
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
                            {
                                id = 'icon_role',
                                widget = wibox.widget.imagebox
                            },
                            top = dpi(4),
                            bottom = dpi(4),
                            right = dpi(3),
                            left = dpi(3),
                            widget = wibox.container.margin
                        },
                        {
                            {
                                id     = 'text_role',
                                widget = wibox.widget.textbox,
                            },
                            strategy = "max",
                            width = dpi(500),
                            widget = wibox.container.constraint
                        },
                        layout = wibox.layout.fixed.horizontal,
                    },
                    left  = 1,
                    right = 10,
                    widget = wibox.container.margin
                },
                widget = clickable_container
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
            widgets.separatorbar,
            s.mypromptbox,
        },
        s.mytasklist, -- Middle widget
        { -- Right widgets
            layout = wibox.layout.fixed.horizontal,
            widgets.mpris_widget,
            widgets.separatorbar,
            widgets.volicon,
            widgets.volumewidget,
--            mykeyboardlayout,
            widgets.separatorbar,
            widgets.mysystray,
            widgets.separatorbar,
            widgets.date,
            widgets.separatorbar,
            widgets.clock,
            widgets.separatorbar,
            s.mylayoutbox,
        },
    }
end
