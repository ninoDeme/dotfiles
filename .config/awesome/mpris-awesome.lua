-------------------------------------------------
-- Modified version of https://github.com/streetturtle/awesome-wm-widgets/tree/master/mpris-widget
-- Modelled after Pavel Makhov's work
-- @author Mohammed Gaber
-- requires - playerctl
-- @copyright 2020
-------------------------------------------------
local awful     = require("awful")
local beautiful = require("beautiful")
local watch     = require("awful.widget.watch")
local wibox     = require("wibox")
local gears     = require("gears")
local markup    = require("lain.util.markup")


--local GET_MPD_CMD = "playerctl -f '{{status}};{{xesam:artist}};{{xesam:title}}' metadata"
local GET_MPD_CMD1 = "playerctl -p "
local GET_MPD_CMD2 = ' -f "{{status}};{{xesam:artist}};{{xesam:title}}" metadata'
--local GET_MPD_CMD = "playerctl -p %s -f '{{status}};{{xesam:artist}};{{xesam:title}}' metadata"

local icon_color = beautiful.fg_icon

local TOGGLE_MPD_CMD   = "playerctl play-pause -p '"
local NEXT_MPD_CMD     = "playerctl next -p '"
local PREV_MPD_CMD     = "playerctl previous -p '"
local LIST_PLAYERS_CMD = "playerctl -l"

local PATH_TO_ICONS     = "/usr/share/icons/Arc"
local PAUSE_ICON_NAME   = gears.color.recolor_image(PATH_TO_ICONS .. "/actions/24/player_pause.png", icon_color)
local PLAY_ICON_NAME    = gears.color.recolor_image(PATH_TO_ICONS .. "/actions/24/player_play.png", icon_color)
local STOP_ICON_NAME    = gears.color.recolor_image(PATH_TO_ICONS .. "/actions/24/player_stop.png", icon_color)
local LIBRARY_ICON_NAME = gears.color.recolor_image(PATH_TO_ICONS .. "/actions/24/music-library.png", icon_color)

Default_player = ''
awful.spawn('bash -c "echo \'\' > ~/.config/awesome/mpris-defaultplayer"')

local icon = wibox.widget {
    id = "icon",
    widget = wibox.widget.imagebox,
    image = PLAY_ICON_NAME
}

local mpris_widget = wibox.widget {

    {
        icon,
        top = 3,
        bottom = 3,
        right = 1,
        widget = wibox.container.margin
    },
    {
        {
            id = 'title',
            widget = wibox.widget.textbox
        },
        right = 2,
        widget = wibox.container.margin
    },
    layout = wibox.layout.fixed.horizontal,
    set_text = function(self, title)
        self:get_children_by_id('title')[1]:set_markup(markup.fontfg(beautiful.font, beautiful.fg_focus, title))
    end
}

local rows = { layout = wibox.layout.fixed.vertical }

local popup = awful.popup {
    bg            = beautiful.bg_normal,
    ontop         = true,
    visible       = false,
    shape         = gears.shape.rounded_rect,
    border_width  = 1,
    border_color  = beautiful.bg_focus,
    maximum_width = 400,
    offset        = { y = 5 },
    widget        = {}
}

-- retrieve song info
local current_song, artist, player_status


local mprisW, mprisTimer = watch("bash -c '" .. GET_MPD_CMD1 .. '"$(<~/.config/awesome/mpris-defaultplayer)"' .. GET_MPD_CMD2 .. "'", 5, function(widget, stdout, _, _, _)
    local words = gears.string.split(stdout, ';')
    player_status = words[1]
    if words[2] ~= nil and words[2] ~= "" then
        artist = words[2] .. " - "
    else
        artist = ""
    end
    current_song = words[3]
    if current_song ~= nil then
        current_song, substituted = string.gsub(current_song, " %- YouTube", "")
        if string.len(current_song) > 40 and substituted == 0 then
            current_song = string.sub(current_song, 0, 40) .. ".."
        elseif string.len(current_song) > 70 then
            current_song = string.sub(current_song, 0, 70) .. ".."
        end
    end

    if player_status == "Playing" then
        icon.image = PLAY_ICON_NAME
--        widget.colors = { beautiful.widget_main_color }
        widget:set_text(artist .. current_song)
    elseif player_status == "Paused" then
        icon.image = PAUSE_ICON_NAME
--        widget.colors = { beautiful.widget_main_color }
        widget:set_text(artist .. current_song)
    elseif player_status == "Stopped" then
        icon.image = STOP_ICON_NAME
    else -- no player is running
        icon.image = LIBRARY_ICON_NAME
--        widget.colors = { beautiful.widget_red }
        widget:set_text("")
    end

end, mpris_widget)

local function rebuild_popup()
    awful.spawn.easy_async(LIST_PLAYERS_CMD, function(stdout, _, _, _)
        for i = 0, #rows do rows[i] = nil end
        for player_name in stdout:gmatch("[^\r\n]+") do
            if player_name ~= '' and player_name ~= nil then

                local checkbox = wibox.widget {
                    {
                        id            = 'checkbox',
                        checked       = player_name == Default_player,
                        color         = beautiful.bg_normal,
                        paddings      = 2,
                        shape         = gears.shape.circle,
                        forced_width  = 20,
                        forced_height = 20,
                        border_color  = beautiful.fg_normal,
                        check_color   = beautiful.fg_urgent,
                        widget        = wibox.widget.checkbox
                    },
                    valign = 'center',
                    layout = wibox.container.place,
                }

                checkbox:connect_signal("button::press", function()
                    Default_player = player_name
                    awful.spawn('bash -c "echo \'' .. Default_player .. '\' > ~/.config/awesome/mpris-defaultplayer"', false, rebuild_popup())
                    mprisTimer:emit_signal("timeout")
                end)

                table.insert(rows, wibox.widget {
                    {
                        {
                            checkbox,
                            {
                                {
                                    text = player_name,
                                    align = 'left',
                                    widget = wibox.widget.textbox
                                },
                                left = 10,
                                layout = wibox.container.margin
                            },
                            spacing = 8,
                            layout = wibox.layout.align.horizontal
                        },
                        margins = 4,
                        layout = wibox.container.margin
                    },
                    bg = beautiful.bg_normal,
                    widget = wibox.container.background
                })
            end
        end
    end)

    popup:setup(rows)
end

mpris_widget:buttons(
    awful.util.table.join(
        awful.button({}, 3, function()
            if popup.visible then
                popup.visible = not popup.visible
            else
                rebuild_popup()
                popup:move_next_to(mouse.current_widget_geometry)
            end
        end),
        awful.button({}, 4, function() awful.spawn(NEXT_MPD_CMD .. Default_player .. "'", false, mprisTimer:emit_signal("timeout") ) end),
        awful.button({}, 5, function() awful.spawn(PREV_MPD_CMD .. Default_player .. "'", false, mprisTimer:emit_signal("timeout") ) end),
        awful.button({}, 1, function() awful.spawn(TOGGLE_MPD_CMD .. Default_player .. "'", false, mprisTimer:emit_signal("timeout") )end)
    )
)
rebuild_popup()
return mprisW

