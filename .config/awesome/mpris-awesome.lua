-------------------------------------------------
-- mpris based Arc Widget for Awesome Window Manager
-- Modelled after Pavel Makhov's work
-- @author Mohammed Gaber
-- requires - playerctl
-- @copyright 2020
-------------------------------------------------
local awful = require("awful")
local beautiful = require("beautiful")
local watch = require("awful.widget.watch")
local wibox = require("wibox")
local gears = require("gears")
local markup = require("lain.util.markup")


--local GET_MPD_CMD = "playerctl -f '{{status}};{{xesam:artist}};{{xesam:title}}' metadata"
local GET_MPD_CMD1 = "playerctl -p "
local GET_MPD_CMD2 = ' -f "{{status}};{{xesam:artist}};{{xesam:title}}" metadata'
local GET_MPD_CMD = "playerctl -p %s -f '{{status}};{{xesam:artist}};{{xesam:title}}' metadata"


local TOGGLE_MPD_CMD = "playerctl play-pause -p '"
local NEXT_MPD_CMD = "playerctl next -p '"
local PREV_MPD_CMD = "playerctl previous -p '"
local LIST_PLAYERS_CMD = "playerctl -l"

local PATH_TO_ICONS = "/usr/share/icons/Arc"
local PAUSE_ICON_NAME = gears.color.recolor_image(PATH_TO_ICONS .. "/actions/24/player_pause.png", "#78A4FF")
local PLAY_ICON_NAME = gears.color.recolor_image(PATH_TO_ICONS .. "/actions/24/player_play.png", "#78A4FF")
local STOP_ICON_NAME = gears.color.recolor_image(PATH_TO_ICONS .. "/actions/24/player_stop.png", "#78A4FF")
local LIBRARY_ICON_NAME = gears.color.recolor_image(PATH_TO_ICONS .. "/actions/24/music-library.png", "#78A4FF")

local default_player = ''
awful.spawn('bash -c "echo \'\'' .. ' > ~/.config/awesome/mpris-defaultplayer"')

local icon = wibox.widget {
    id = "icon",
    widget = wibox.widget.imagebox,
    image = PLAY_ICON_NAME
}

local mpris_widget = wibox.widget{
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
        self:get_children_by_id('title')[1]:set_markup(markup.fontfg("NotoSans Nerd Font 10" ,"#ffffff", title))
    end
}

local rows  = { layout = wibox.layout.fixed.vertical }

local popup = awful.popup{
    bg = beautiful.bg_normal,
    ontop = true,
    visible = false,
    shape = gears.shape.rounded_rect,
    border_width = 1,
    border_color = beautiful.bg_focus,
    maximum_width = 400,
    offset = { y = 5 },
    widget = {}
}

local function rebuild_popup()
    awful.spawn.easy_async(LIST_PLAYERS_CMD, function(stdout, _, _, _)
        for i = 0, #rows do rows[i]=nil end
        for player_name in stdout:gmatch("[^\r\n]+") do
            if player_name ~='' and player_name ~=nil then

                local checkbox = wibox.widget{
                    {
                        id = 'checkbox',
                        checked       = player_name == default_player,
                        color         = beautiful.bg_normal,
                        paddings      = 2,
                        shape         = gears.shape.circle,
                        forced_width = 20,
                        forced_height = 20,
                        check_color = beautiful.fg_urgent,
                        widget        = wibox.widget.checkbox
                    },
                    valign = 'center',
                    layout = wibox.container.place,
                }

                checkbox:connect_signal("button::press", function()
                    default_player = player_name
                    awful.spawn('bash -c "echo \'' .. default_player .. '\' > ~/.config/awesome/tempm"')
                    rebuild_popup()
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

local function worker()

    -- retrieve song info
    local current_song, artist, player_status

    local update_graphic = function(widget, stdout, _, _, _)
        local words = gears.string.split(stdout, ';')
        player_status = words[1]
        if words[2] ~= nil and words[2] ~= "" then
        artist = words[2] .. " - "
        else
            artist = ""
        end
        current_song = words[3]
        if current_song ~= nil then
            if string.len(current_song) > 100 then
                current_song = string.sub(current_song, 0, 100) .. ".."
            end
        end

        if player_status == "Playing" then
            icon.image = PLAY_ICON_NAME
            widget.colors = {beautiful.widget_main_color}
            widget:set_text(artist .. current_song)
        elseif player_status == "Paused" then
            icon.image = PAUSE_ICON_NAME
            widget.colors = {beautiful.widget_main_color}
            widget:set_text(artist .. current_song)
        elseif player_status == "Stopped" then
            icon.image = STOP_ICON_NAME
        else -- no player is running
            icon.image = LIBRARY_ICON_NAME
            widget.colors = {beautiful.widget_red}
            widget:set_text("")
        end
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
                    awful.button({}, 4, function() awful.spawn(NEXT_MPD_CMD .. default_player .. "'", false) end),
                    awful.button({}, 5, function() awful.spawn(PREV_MPD_CMD .. default_player .. "'", false) end),
                    awful.button({}, 1, function() awful.spawn(TOGGLE_MPD_CMD .. default_player .. "'", false) end)
            )
    )
    watch("bash -c '" .. GET_MPD_CMD1 .. '"$(<~/.config/awesome/mpris-defaultplayer)"' .. GET_MPD_CMD2 .. "'", 2, update_graphic, mpris_widget)
--    watch(GET_MPD_CMD, 1, update_graphic, mpris_widget)

    return mpris_widget

end

return setmetatable(mpris_widget, {__call = function(_, ...) return worker(...) end})