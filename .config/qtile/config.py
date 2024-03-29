# Qtile config

import os
import subprocess

from curses.ascii import alt
from turtle import color
from libqtile import bar, layout, widget, hook
from libqtile.config import Click, Drag, Group, Key, Match, Screen
from libqtile.lazy import lazy
from libqtile.utils import guess_terminal
from pygments import highlight

from themes import gruvbox, arc

theme = arc
with open(os.path.expanduser("~/.config/DefaultTerm")) as f:
    terminal = f.read()
mod = "mod4"
scripts = os.path.expanduser("~/scripts/")

@hook.subscribe.startup_once
def autostart():
    home = os.path.expanduser('~/.config/qtile/autostart.sh')
    subprocess.Popen([home])


keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key(["mod1"], "Tab", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod, "control"], "Return", lazy.layout.shuffle_left(), desc="Make focused window Master"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod], "i", lazy.layout.grow(), desc="Grow window to the left"),
    Key([mod], "m", lazy.layout.shrink(), desc="Grow window to the right"),
#    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
#    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "t", lazy.window.toggle_floating(), desc="Toggle floating"),
    Key([mod], "f", lazy.window.toggle_fullscreen(), desc="Toggle floating"),

    # Toggle between split and unsplit sides of stack.
    # Split = all windows displayed
    # Unsplit = 1 window displayed, like Max layout, but still with
    # multiple stack panes
    Key(
        [mod, "shift"],
        "Return",
        lazy.layout.toggle_split(),
        desc="Toggle between split and unsplit sides of stack",
    ),
    Key([mod], "Return", lazy.spawn(terminal), desc="Launch terminal"),
    Key([mod], "s", lazy.spawn("steam"), desc="Launch steam"),
    Key([mod, "shift"], "s", lazy.spawn("lutris"), desc="Launch lutris"),
    Key([mod], "d", lazy.spawn("flatpak run com.discordapp.Discord"), desc="Launch discord"),
    Key([mod], "b", lazy.spawn("firefox"), desc="Launch firefox"),
    Key([mod], "c", lazy.spawn("code"), desc="Launch firefox"),
    Key([mod, "control"], "c", lazy.spawn(scripts + "open_project.sh"), desc="Launch firefox"),


    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([], "Print", lazy.spawn("flameshot gui")),
    Key([mod, "control"], "space", lazy.spawn(scripts + "dmenu-exec.sh"), desc = "Run dmenu"),
    Key([mod,], "space", lazy.spawn("rofi -show combi"), desc = "Run rofi"),
    Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),

    Key(["mod1"], "F4", lazy.spawn("xkill"), desc="Force kill window"),
    Key([mod, "shift"], "c", lazy.window.kill(), desc="Kill focused window"),

    Key([mod, "shift"], "r", lazy.restart(), desc="Reload the config"),
    Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    Key([mod, "shift"], "q", lazy.spawn(scripts + "rofi-power.sh") , desc="Power menu"),
]

groups = [Group(i) for i in "123456789"]

for i in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                i.name,
                lazy.group[i.name].toscreen(),
                desc="Switch to group {}".format(i.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                i.name,
                lazy.window.togroup(i.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(i.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )
floating_layout = layout.Floating(
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
    ]
)
layouts = [
#    layout.Columns(),
    layout.MonadTall(
        border_focus= theme.fg_active,
        border_normal= theme.bg, 
        border_width=3,
        margin = 5,
        ratio = 0.55,
        single_border_width = 0,
        single_margin = 0),
    layout.Max(),
    # Try more layouts by unleashing below layouts.
    # layout.Stack(num_stacks=2),
    # layout.Bsp(),
    # layout.Matrix(),
    # layout.MonadWide(),
    # layout.RatioTile(),
    # layout.Tile(),
    # layout.TreeTab(),
    # layout.VerticalTile(),
    # layout.Zoomy(),
]

widget_defaults = dict(
    font="NotoSans Nerd Font",
    fontsize=12,
    padding=3,
)
extension_defaults = widget_defaults.copy()





screens = [
    Screen(
        wallpaper = theme.wallpaper,
        wallpaper_mode='fill',
        top=bar.Bar(
            [
                widget.GroupBox(
                    highlight_method= 'block',
                    active = theme.fg_active,
                    inactive = theme.fg_minimized,
                    this_current_screen_border = theme.bgalt,
                    rounded = False),
                widget.Prompt(foreground = theme.fg),
                widget.CurrentLayout(foreground = theme.fgalt, background = theme.bgalt, padding = 6),
                # widget.WindowName(foreground = theme.fg, padding = 6),
                widget.TaskList(
                    foreground = theme.fg_active,
                    borderwidth = 0,
                    margin_x = 3,
                    margin = 0,
                    fontsize = 12,
                    padding = 3,
                    icon_size = 0,
                    txt_floating = "🗗",
                    txt_maximized = "🗖",
                    txt_minimized = "🗕 ",
                    highlight_method= 'block',
                    border = theme.bgalt,
                    rounded = False),
                widget.Chord(
                    chords_colors={
                        "launch": ("#ff0000", "#ffffff"),
                    },
                    name_transform=lambda name: name.upper(),
                ),
                widget.Systray(padding = 2),
                widget.Spacer(5),
                widget.Clock(format="%a %d/%m/%Y %H:%M", 
                foreground = theme.fgalt,
                background = theme.bgalt,
                padding = 6,),
                widget.Spacer(3)
            ],
            21,
            background = theme.bg,
#            foreground = theme.fg
            # border_width=[2, 0, 2, 0],  # Draw top and bottom borders
            # border_color=["ff00ff", "000000", "ff00ff", "000000"]  # Borders are magenta
        ),
    ),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False

auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True

# If things like steam games want to auto-minimize themselves when losing
# focus, should we respect this or not?
auto_minimize = True

# When using the Wayland backend, this can be used to configure input devices.
wl_input_rules = None


    

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, GitHub issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"
