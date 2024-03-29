
-------------------------------------------------------------------
--               Awesome config file by ninoDeme                 --
-- Rest of my configs: https://www.github.com/ninoDeme/dotfiles  --
-------------------------------------------------------------------

-- Imports {{{
-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

os.setlocale(os.getenv("LC_TIME"))

local gears               = require("gears")
local awful               = require("awful") -- Standard awesome library
local wibox               = require("wibox") -- Widget and layout library
local beautiful           = require("beautiful") -- Theme handling library
local naughty             = require("naughty") -- Notification library
local menubar             = require("menubar")
local hotkeys_popup       = require("awful.hotkeys_popup")
local lain                = require("lain") -- External widgets
local icons               = require('icons') -- Icons
local apps                = require("configuration.apps")
local clickable_container = require("clickable-container")
require("awful.autofocus")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
--require("awful.hotkeys_popup.keys")
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err) })
        in_error = false
    end)
end

-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

local exit_screen_show = require("exit_screen")

-- }}}

-- Function declarations {{{
local function findProgram(programName, ifSucces)
    awful.spawn.easy_async(
        "pgrep -i " .. programName,
        function(stdout, stderr, reason, exitcode)
          if exitcode ~= 0 then
                if ifSucces ~= nil then ifSucces() 
                else awful.spawn(programName) end
            end
        end
    )
end

local function run_once(cmd)
    local findme = cmd
    local firstspace = cmd:find(' ')
    if firstspace then
        findme = cmd:sub(0, firstspace - 1)
    end
    awful.spawn(string.format('bash -c "pgrep -u $USER -x %s > /dev/null || (%s)"', findme, cmd))
end

local function findWindow(windowName, ifSucces)
    awful.spawn.easy_async(
        "bash -c 'wmctrl -l | grep " .. windowName .. " -o -i'",
        function(stdout, stderr, reason, exitcode)
            if exitcode ~= 0 then
                ifSucces()
            end
        end)
end

local function findWindowScreen(windowName, ifSucces, s, t)
    local condit = true
    for _, c in ipairs(client.get(s)) do
        if not (c.class == nil) then
            if string.match(c.class, windowName) and (t == nil or c.first_tag == t) then
                condit = false
            end
        end
    end
    if condit then ifSucces() end
end
--- }}}

-- {{{ Variable definitions

-- dont use gap when theres only 1 window
beautiful.gap_single_client = false

-- This is used later as the default terminal and editor to run.
local terminal = apps.default.terminal
local browser = apps.default.browser
local editor = apps.default.termeditor
local editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

--awful.layout.floating.resize_jump_to_corner = false
-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.tile,
    -- awful.layout.suit.floating,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    -- awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    -- awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
    menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it

-- beautiful.init(gears.filesystem.get_themes_dir() .. "gtk/theme.lua")

local hotkeys_popup_sized = hotkeys_popup.widget.new({ width = 700, height = 780 });

mymainmenu = awful.menu({ items = {
    { "hotkeys", function() hotkeys_popup_sized:show_help(nil, awful.screen.focused()) end },
    { "manual", terminal .. " -e man awesome" },
    { "edit config", "code " .. gears.filesystem.get_configuration_dir() },
    { "open terminal", terminal },
    { "restart awesome", awesome.restart },
    { "quit", function() exit_screen_show() end },
}
})

-- }}}

-- Signals {{{

-- Close menu on mouse leave
mymainmenu.wibox:connect_signal("mouse::leave", function()
    if not mymainmenu.active_child or
        (mymainmenu.wibox ~= mouse.current_wibox and
            mymainmenu.active_child.wibox ~= mouse.current_wibox) then
        mymainmenu:hide()
    else
        mymainmenu.active_child.wibox:connect_signal("mouse::leave",
            function()
                if mymainmenu.wibox ~= mouse.current_wibox then
                    mymainmenu:hide()
                end
            end)
    end
end)

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)

local discordTags = {}
local browserTags = {}
local gamingTags = {}

require("panel")

awful.screen.connect_for_each_screen(function(s)
    -- Wallpaper
    local wallpaper = beautiful.wallpaper
    if type(wallpaper) == "function" then
        wallpaper = wallpaper(s)
    end
    gears.wallpaper.maximized(wallpaper, s, true)

    -- Each screen has its own tag table.
    awful.tag({ "1", "2", "3", "4", "5", "", "ﭮ"}, s, awful.layout.layouts[1])

    table.insert(gamingTags, awful.tag.add("" , {
        layout             = awful.layout.suit.max.fullscreen,
        layouts = awful.layout.layouts,
        gap                = 0,
        screen             = s,
    }))

    table.insert(discordTags, awful.tag.find_by_name(s, "ﭮ"))
    table.insert(browserTags, awful.tag.find_by_name(s, ""))

    beautiful.at_screen_connect(s) 

end)

-- Tags
local discordTag = awful.tag.find_by_name(awful.screen.focused(), "ﭮ")
local browserTag = awful.tag.find_by_name(awful.screen.focused(), "")


-- Add titlebars on floating layout
tag.connect_signal("property::layout", function(t)
    for _ , c in ipairs(t.screen.all_clients) do
        if c.requests_no_titlebar == false and t.layout == awful.layout.suit.floating then
            awful.titlebar.show(c)
        else
            awful.titlebar.hide(c)
        end
    end
end)

-- Add titlebars on floating windows
client.connect_signal("property::floating", function(c)
    if c.floating then
        c.ontop = true
    else
        c.ontop = false
    end
end)

-- Clients aren't urgent when spawned
client.disconnect_signal("request::activate", awful.ewmh.activate)
function awful.ewmh.activate(c)
    if c:isvisible() then
        client.focus = c
        c:raise()
    end
end

client.connect_signal("request::activate", awful.ewmh.activate)

--[[ client.connect_signal("request::activate", function(c)
    cond = true
    if c.first_tag == gamingTags[1] then
        awful.spawn("killall picom")
    else
        run_once('picom --experimental-backends --config ' .. gears.filesystem.get_configuration_dir() .. '/configuration/picom.conf')
    end
end) ]]
--client.connect_signal("manage", function (c)
--    c.shape = function(cr,w,h)
--        gears.shape.rounded_rect(cr,w,h,15)
--    end
--end)

screen.connect_signal("arrange", function(s)
    local only_one = #s.tiled_clients == 1
    for _, c in pairs(s.clients) do
        if only_one and not c.floating or c.maximized or c.fullscreen then
            c.border_width = 0
        else
            c.border_width = beautiful.border_width
        end
    end
end)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    if not awesome.startup then awful.client.setslave(c) end
    -- if not awesome.startup and c.first_tag == awful.tag.find_by_name("5") then awful.client.setslave(c) end

    if awesome.startup
        and not c.size_hints.user_position
        and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end

end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = false })
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
    awful.button({}, 3, function() mymainmenu:toggle() end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey, }, "F1", function() hotkeys_popup_sized:show_help(nil, awful.screen.focused()) end,
        { description = "show help", group = "awesome" }),
    awful.key({ modkey, }, "Left", awful.tag.viewprev,
        { description = "view previous", group = "tag" }),
    awful.key({ modkey, }, "Right", awful.tag.viewnext,
        { description = "view next", group = "tag" }),
    awful.key({modkey}, 'z', awful.tag.history.restore,
        {description = 'go back', group = 'tag'}),

    awful.key({ modkey, }, "j",
        function()
            awful.client.focus.byidx(1)
        end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key({ modkey, }, "k",
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous by index", group = "client" }
    ),
    awful.key({ modkey, }, "w", function() mymainmenu:show() end,
        { description = "show main menu", group = "awesome" }),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey, "Control" }, "j", function() awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey, "Control" }, "k", function() awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }),
    awful.key({}, "XF86AudioRaiseVolume", function() awful.spawn("pactl set-sink-volume 0 +4%") end),
    awful.key({}, "XF86AudioLowerVolume", function() awful.spawn("pactl set-sink-volume 0 -4%") end),
    awful.key({}, "XF86AudioMute", function() awful.spawn("pactl set-sink-mute 0 toggle") end),
    awful.key({}, "XF86AudioPlay", function () awful.util.spawn("playerctl play-pause -p '" .. Default_player .. "'") end),
    awful.key({}, "XF86AudioNext", function () awful.util.spawn("playerctl next -p '" .. Default_player .. "'") end),
    awful.key({}, "XF86AudioPrev", function () awful.util.spawn("playerctl previous -p '" .. Default_player .. "'") end),


    -- Standard program
    awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }),
        awful.key({ modkey, }, "x", function() awful.spawn(terminal) end,
        { description = "open a terminal", group = "launcher" }),

    awful.key({ modkey, "Shift" }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "q", function() exit_screen_show() end,
        { description = "quit awesome", group = "awesome" }),

    awful.key({ modkey, }, "l", function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),
    awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
        { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }),
    awful.key({ modkey, }, "Tab", function() awful.layout.inc(1) end,
        { description = "select next", group = "layout" }),
    awful.key({ modkey, "Control" }, "t", function() 
        if awful.layout.get() == awful.layout.suit.floating
            then awful.layout.set( awful.layout.suit.tile )
            else awful.layout.set( awful.layout.suit.floating )
        end
    end,
        { description = "select next", group = "layout" }),
    awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(-1) end,
        { description = "select previous", group = "layout" }),

    awful.key({ modkey, "Control" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal(
                    "request::activate", "key.unminimize", { raise = true }
                )
            end
        end,
        { description = "restore minimized", group = "client" }),

    -- Prompt
    awful.key({ modkey }, "r", function() awful.screen.focused().mypromptbox:run() end,
        { description = "run prompt", group = "launcher" }),

    awful.key({ modkey, "Shift" }, "r",
        function()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        { description = "lua execute prompt", group = "awesome" }),
    -- Menubar
    awful.key({ modkey }, "space", function() menubar.show() end,
        { description = "show the menubar", group = "launcher" }),

    -- Rofi
    awful.key({ modkey, "Control" }, "space", function() awful.spawn("rofi -show combi") end,
        { description = "show rofi", group = "launcher" }),

    -- bwmenu
    awful.key({ modkey, "Control" }, "r", function() awful.spawn("bwmenu") end,
        { description = "show bitwarden menu", group = "launcher" }),

    -- Aplications
    awful.key({ modkey, "Shift" }, "e", function() awful.spawn(apps.default.files) end,
        { description = "Open file manager", group = "Applications" }),

    -- Aplications
    awful.key({ modkey }, "e", function() awful.spawn(terminal .. " -e " .. apps.default.termfiles) end,
        { description = "Open terminal file manager", group = "Applications" }),

    awful.key({ modkey }, "s", function() awful.spawn("steam") end,
        { description = "Open steam", group = "Applications" }),
    awful.key({ modkey, "Shift" }, "s", function() awful.spawn("lutris") end,
        { description = "Open lutris", group = "Applications" }),

    awful.key({ modkey }, "c", function() awful.spawn(apps.default.editor) end,
        { description = "Open editor", group = "Applications" }),

    awful.key({ modkey, "Control" }, "c", function() awful.spawn("sh -c '$HOME/scripts/open_project.sh'") end,
        { description = "Edit awesome config", group = "Applications" }),

    awful.key({}, "Print", function() awful.spawn("flameshot gui") end),

    awful.key({ modkey }, "d", function()
        findWindow("Discord", function() awful.spawn(apps.default.discord, {tag = discordTags }) end)
        discordTags[1]:view_only()
        for _, c in ipairs(client.get(s)) do
            if string.match(c.name, "Discord") then
                c:move_to_tag(discordTags[1])
            end
        end
    end,
        { description = "Spawn discord", group = "Applications" }),
    awful.key({ modkey, "Control" }, "d", function()
        findWindow("Discord", function() awful.spawn(apps.default.discord, {tag = discordTags }) end)
        for i in pairs(discordTags) do
            awful.tag.viewtoggle(i)
        end
        -- awful.tag.viewtoggle(discordTag)
    end,
        { description = "Toggle discord", group = "Applications" }),
    awful.key({ modkey, "Mod1" }, "d", function()
        findWindow("Discord", function() awful.spawn(apps.default.discord, {tag = discordTags }) end)
        discordTags[#discordTags]:view_only()
        for _, c in ipairs(client.get(s)) do
            if string.match(c.name, "Discord") then
                c:move_to_tag(discordTags[#discordTags])
            end
        end
    end,
        { description = "Spawn discord", group = "Applications" }),

    awful.key({ modkey }, "b", function()
        findWindowScreen(browser,
            function()
                awful.spawn(browser, { tag = awful.tag.find_by_name(awful.screen.focused(), "") })
            end,
            awful.screen.focused(),
            awful.tag.find_by_name(awful.screen.focused(), ""))
        awful.tag.find_by_name(awful.screen.focused(), ""):view_only()
    end,
        { description = "Spawn browser", group = "Applications" }),
    awful.key({ modkey, "Shift" }, "b",
        function()
            if client.focus then
                client.focus:move_to_tag(awful.tag.find_by_name(awful.screen.focused(), ""))
            end
        end,
    { description = "move focused client to browser tag" , group = "Applications" }),
    awful.key({ modkey, "Control" }, "b", function()
        findProgram(browser, function() awful.spawn(browser, {tag = browserTag }) end)
        awful.tag.viewtoggle(awful.tag.find_by_name(awful.screen.focused(), ""))
    end,
        { description = "Toggle browser", group = "Applications" }),
    awful.key({ modkey, "Mod1" }, "b", function()
        findWindowScreen(browser,
            function()
                awful.spawn(browser, { tag = browserTags[#browserTags] })
            end,
            browserTags[#browserTags].screen,
            browserTags[#browserTags])
        browserTags[#browserTags]:view_only()
    end,
        { description = "Spawn browser in last screen", group = "Applications" }),
    awful.key({ modkey, "Mod1", "Shift" }, "b",
        function()
            if client.focus then
                client.focus:move_to_tag(browserTags[#browserTags])
            end
        end,
    { description = "move focused client to browser tag" , group = "Applications" }),

    awful.key({ modkey }, "g",
        function()
            gamingTags[1]:view_only()
        end,
    { description = "open gaming tag" , group = "Gaming" }),
    awful.key({ modkey, "Shift" }, "g",
        function()
            if client.focus then
                client.focus:move_to_tag(gamingTags[1])
                gamingTags[1]:view_only()
            end
        end,
    { description = "move focused client to gaming tag" , group = "Gaming" }),

    awful.key({ modkey, "Mod1" }, "g",
        function()
            awful.spawn("killall picom")
        end,
    { description = "Kill compositor" , group = "Gaming" }),
    awful.key({ modkey, "Mod1", "Control" }, "g",
        function()
            awful.spawn('picom --experimental-backends')
        end,
    { description = "open compositor" , group = "Gaming" })
)

clientkeys = gears.table.join(
    awful.key({ modkey, }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }),
--    awful.key({ modkey, "Shift" }, "c", function(c) c:kill() end,
    awful.key({ modkey, "Shift" }, "c" , function () awful.spawn("sh " .. gears.filesystem.get_configuration_dir() .. "/KillOrSteam.sh") end,
        { description = "close", group = "client" }),
    awful.key({ "Mod1" }, "F4" , function () awful.spawn("xkill") end,
        { description = "kill (select)", group = "client" }),
        awful.key({ "Mod1", "Shift" }, "F4",
        function (c)
            if c.pid then
                awful.spawn("kill -9 " .. c.pid)
            end
        end,
        { description = "kill (active)", group = "client" }),
    awful.key({ modkey }, "t", awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }),
    awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }),
    awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
        { description = "move to screen", group = "client" }),
    awful.key({ modkey, "Shift" }, "t", function(c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "client" }),
    awful.key({ modkey, }, "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        { description = "minimize", group = "client" }),
    awful.key({ modkey, }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "(un)maximize", group = "client" }),
    awful.key({ modkey, "Control" }, "m",
        function(c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end,
        { description = "(un)maximize vertically", group = "client" }),
    awful.key({ modkey, "Shift" }, "m",
        function(c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end,
        { description = "(un)maximize horizontally", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end),
--            { description = "view tag #" .. i, group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end),
--            { description = "toggle tag #" .. i, group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                        tag:view_only()
                    end
                end
            end),
--            { description = "move focused client to tag #" .. i, group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end)
--            { description = "toggle focused client on tag #" .. i, group = "tag" })
    )
end

-- tag switch descriptions
globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#", function() end,
            { description = "view tag #", group = "tag" }),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#", function() end,
            { description = "toggle tag #", group = "tag" }),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#", function() end,
            { description = "move focused client to tag #", group = "tag" }),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#", function() end,
            { description = "toggle focused client on tag #", group = "tag" })
)

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = {},
        properties = { border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen
        }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
            "DTA", -- Firefox addon DownThemAll.
            "copyq", -- Includes session name in class.
            "pinentry",
        },
        class = {
            "Pavucontrol",
            "Arandr",
            "Blueman-manager",
            "Gpick",
            "Kruler",
            "MessageWin", -- kalarm.
            "Sxiv",
            "Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
            "Wpa_gui",
            "veromix",
            "xtightvncviewer" },

        -- Note that the name property shown in xprop might be set slightly after creation of the client
        -- and the name shown there might not match defined rules here.
        name = {
            "Event Tester", -- xev.
        },
        role = {
            "AlarmWindow", -- Thunderbird's calendar.
            "ConfigManager", -- Thunderbird's about:config.
            "pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
        }
    }, properties = { floating = true } },

    { rule = { class = "discord" },
        properties = { tag = discordTags[#discordTags] } },

    { rule = { class = "Chromium" },
        properties = { floating = false,  tag = discordTags[#discordTags] } },
    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- Titlebar {{{ 

local function clickable_container_circle(cr)
    return {
        cr,
        shape = gears.shape.circle,
        widget = clickable_container
    }
end

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )


    awful.titlebar(c, { size = 20}):setup {
        {
            { -- Left
                awful.titlebar.widget.iconwidget(c),
                buttons = buttons,
                layout  = wibox.layout.fixed.horizontal
            },
            { -- Middle
                { -- Title
                    align  = "center",
                    widget = awful.titlebar.widget.titlewidget(c)
                },
                buttons = buttons,
                layout  = wibox.layout.flex.horizontal
            },
            { -- Right
                clickable_container_circle(awful.titlebar.widget.minimizebutton(c)),
                clickable_container_circle(awful.titlebar.widget.maximizedbutton(c)),
                clickable_container_circle(awful.titlebar.widget.closebutton(c)),
                layout = wibox.layout.fixed.horizontal()
            },
            layout = wibox.layout.align.horizontal
        },
    left = 2,
    top = 2,
    bottom = 2,
    widget = wibox.container.margin
    }
end)
-- }}}

-- Autostart {{{

--awful.spawn.single_instance("flatpak run com.discordapp.Discord", {})
-- findProgram("discord", apps.default.discord)
findWindow("Discord", function() awful.spawn(apps.default.discord, {tag = "ﭮ" }) end)
--run_once("flatpak run com.discordapp.Discord")

for _, app in ipairs(apps.run_on_start_up) do
    run_once(app)
end
-- }}}
