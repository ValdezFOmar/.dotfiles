# fmt: off

from pathlib import Path

from libqtile import bar, layout, widget
from libqtile.config import Click, Drag, Group, Key, KeyChord, Match, Screen
from libqtile.lazy import lazy

#from libqtile.utils import guess_terminal


# Mod keys
alt = "mod1"
mod = "mod4"

# Programs
terminal = "kitty"
file_exp = "pcmanfm"
menu_launcher = "rofi -show drun"

scripts_dir = Path.home() / ".local" / "bin"
power_menu = str(scripts_dir / "powermenu")
frequency_menu = str(scripts_dir / "frequencymenu")


class ColorTheme:
    LITERAL_BLACK   = "#000000"
    BLACK           = "#1b1d1e"
    LIGHT_BLACK     = "#505354"
    RED             = "#f92672"
    LIGHT_RED       = "#ff669d"
    GREEN           = "#a6e22e"
    LIGHT_GREEN     = "#beed5f"
    YELLOW          = "#fd971f"
    LIGHT_YELLOW    = "#e6db74"
    BLUE            = "#1989EB"
    LIGHT_BLUE      = "#66d9ef"
    MAGENTA         = "#9e6ffe"
    LIGHT_MAGENTA   = "#66d9ef"
    CYAN            = "#5e7175"
    LIGHT_CYAN      = "#a3babf"
    WHITE           = "#ccccc6"
    LIGHT_WHITE     = "#f8f8f2"


keys = [
    # A list of available commands that can be bound to keys can be found
    # at https://docs.qtile.org/en/latest/manual/config/lazy.html
    # Switch between windows
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    # Move windows between left/right columns or move up/down in current stack.
    # Moving out of range in Columns layout will create new column.
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    # Grow windows. If current window is on the edge of screen and direction
    # will be to screen edge - window would shrink.
    Key([mod, "control"], "h", lazy.layout.grow_left(), desc="Grow window to the left"),
    Key([mod, "control"], "l", lazy.layout.grow_right(), desc="Grow window to the right"),
    Key([mod, "control"], "j", lazy.layout.grow_down(), desc="Grow window down"),
    Key([mod, "control"], "k", lazy.layout.grow_up(), desc="Grow window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
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
    # Toggle between different layouts as defined below
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    #Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    #Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),


    # Custom keybinds
    Key([mod, alt], "f", lazy.window.toggle_floating(), desc="Switch between float a tiling window"),
    Key([mod], "b", lazy.spawn("firefox"), desc="Launch firefox browser"),
    Key([mod, alt], "b", lazy.spawn("firefox -P School"), desc="Launch firefox browser with school profile"),
    Key([mod], "e", lazy.spawn(file_exp), desc="Launch a file explorer"),
    Key([mod], "q", lazy.spawn(power_menu), desc="Launch power menu"),
    Key([mod], "m", lazy.spawn(menu_launcher), desc="Open menu launcher for programs"),

    # Tooling (mod + T + <key>), for using general purpose tools
    KeyChord([mod], "t", [
            Key([], "p", lazy.spawn("xcolor -f HEX -P 155 -s clipboard"), desc="Color picker"),
            Key([], "h", lazy.spawn("gpaste-client ui"), desc="Clipboard history"),
        ],
        name="tool"
    ),

    # Hardware Keybinds
    # Note: Both volume and backlight are configure to be more accuarate to human perception
    Key([], "XF86MonBrightnessUp", lazy.spawn("xbacklight -perceived -inc 5"), desc="Increse screen lightness"),
    Key([], "XF86MonBrightnessDown", lazy.spawn("xbacklight -perceived -dec 5"), desc="Decrese screen lightness"),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pamixer -i 5 --gamma 2"), desc="Increase volume"),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pamixer -d 5 --gamma 2"), desc="Decrease volume"),
    Key([], "XF86AudioMute", lazy.spawn("pamixer -t"), desc="Toggle mute"),
    Key([], "Print", lazy.spawn("gnome-screenshot --area --interactive"), desc="Launch snipping tool")
]

groups = [Group(name=i, label=i.upper()) for i in "asdfuiop"]

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


# Layouts
layouts_config = {
    'margin': 4,
    'margin_on_single': False,
    'border_width': 2,
    'border_normal': ColorTheme.LIGHT_BLACK,
    'border_focus': ColorTheme.MAGENTA,
    'border_on_single': False,
}

monad_layout_config = {
    'ratio': 0.55,
    'single_margin': 0,
    'single_border_width': 0,
}

layouts = [
    layout.MonadTall(**layouts_config, **monad_layout_config),
    layout.MonadWide(**layouts_config, **monad_layout_config),
    layout.Zoomy(**layouts_config),
    layout.Columns(**layouts_config),
    layout.VerticalTile(**layouts_config),
    # Try more layouts by unleashing below layouts.
    # layout.Max(**layouts_config),
    # layout.Stack(num_stacks=4),
    # layout.Bsp(**layouts_config),
    # layout.Matrix(**layouts_config),
    # layout.RatioTile(**layouts_config),
    # layout.Tile(**layouts_config),
    # layout.TreeTab(**layouts_config),
]

# Widgets
widget_defaults = dict(
    font="sans",
    fontsize=16,
    padding=6,
    foreground=ColorTheme.LIGHT_WHITE,
)
extension_defaults = widget_defaults.copy()


w_group_config = {
    "active": ColorTheme.WHITE,
    "highlight_method": "block",
    "this_screen_border": ColorTheme.BLUE,
    "this_current_screen_border": ColorTheme.BLUE,
    "block_highlight_text_color": ColorTheme.BLACK,
    "inactive": ColorTheme.LIGHT_BLACK,
    "spacing":3,
}
#widget.Prompt()
w_chord = widget.Chord(
    chords_colors={
        "launch": (ColorTheme.RED, ColorTheme.WHITE),
        "tool": (ColorTheme.RED, ColorTheme.WHITE),
    },
    name_transform=lambda name: name.title(),
)
# NB Systray is incompatible with Wayland, consider using StatusNotifier instead
# widget.StatusNotifier()
#widget.Systray()
w_volume = widget.Volume(fmt='Vol: {}', foreground=ColorTheme.MAGENTA)
w_battery = widget.Battery(
    update_interval=1, # seconds
    format="{char} {percent:2.0%}",
    discharge_char="B",
    low_foreground=ColorTheme.LIGHT_RED,
    low_percentage=0.2,
    foreground=ColorTheme.YELLOW,
    mouse_callbacks={
        "Button1": lazy.spawn(frequency_menu),
    },
)
w_date = widget.Clock(format="%A %d/%b/%Y", foreground=ColorTheme.LIGHT_BLUE)
w_time = widget.Clock(format="%I:%M %p", foreground=ColorTheme.GREEN)


# Screens
monitor_wallpaper="/usr/share/backgrounds/archlinux/archwave.png"

screens = [
    Screen(
        wallpaper=monitor_wallpaper,
        wallpaper_mode="fill",
        bottom=bar.Bar(
            [
                widget.CurrentLayoutIcon(scale=0.8),
                widget.GroupBox(**w_group_config),
                widget.WindowName(),
                w_chord,
                w_volume,
                w_battery,
                w_date,
                w_time,
            ],
            28,
            #border_width=[0, 0, 0, 0],  # top, right, bottom, left
            #border_color=["", "", "", ",
            background=ColorTheme.BLACK,
        ),
    ),
    Screen(
        wallpaper=monitor_wallpaper,
        wallpaper_mode="fill",
        bottom=bar.Bar(
            [
                widget.CurrentLayoutIcon(scale=0.8),
                widget.GroupBox(**w_group_config),
                widget.WindowName(),
                w_chord,
                w_volume,
                w_battery,
                w_date,
                w_time,
            ],
            28,
            background=ColorTheme.BLACK,
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
bring_front_click = "floating_only"
cursor_warp = False
floating_layout = layout.Floating(
    border_width=1,
    border_focus=ColorTheme.WHITE,
    border_normal=ColorTheme.LITERAL_BLACK,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry

        Match(title="V Bibliography Database", wm_class="libreoffice"),
        Match(wm_instance_class="Toplevel", wm_class="Zotero"), # Zotero dialogs on LibreOffice
        Match(title="Library", wm_class="Places"),  # firefox downloads menu
        Match(title="nsxiv", wm_class="float"),
        Match(title="Dear PyGui", wm_class="Dear PyGui"),
        Match(wm_class="gnome-screenshot"), # Preview screenshot window

        # Float all windows that are the child of a parent window
        # Match(func=lambda c: bool(c.is_transient_for())),
    ]
)
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
