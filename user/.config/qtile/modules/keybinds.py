from libqtile.config import Click, Drag, Key, KeyChord
from libqtile.lazy import lazy

from .groups import groups
from .vars import alt, file_explorer, menu_launcher, mod, power_menu, terminal

__all__ = ["keys"]

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
    # Key([mod, "control"], "q", lazy.shutdown(), desc="Shutdown Qtile"),
    # Key([mod], "r", lazy.spawncmd(), desc="Spawn a command using a prompt widget"),
    # Custom keybinds
    Key([mod, alt], "f", lazy.window.toggle_floating(), desc="Switch between float a tiling window"),
    Key([mod], "b", lazy.spawn("firefox"), desc="Launch firefox browser"),
    Key([mod, alt], "b", lazy.spawn("firefox -P School"), desc="Launch firefox browser with school profile"),
    Key([mod], "e", lazy.spawn(file_explorer), desc="Launch a file explorer"),
    Key([mod], "q", lazy.spawn(power_menu), desc="Launch power menu"),
    Key([mod], "m", lazy.spawn(menu_launcher), desc="Open menu launcher for programs"),
    KeyChord(
        [mod],
        "t",
        [
            Key(
                [], "p", lazy.spawn("xcolor --format HEX --preview-size 155 --selection"), desc="Color picker"
            ),
            Key([], "h", lazy.spawn("gpaste-client ui"), desc="Clipboard history"),
        ],
        name="tool",
        desc="Tooling (mod + T + <key>), for using general purpose tools",
    ),
    # Hardware Keybinds
    # Note: Both volume and backlight are configure to be more accuarate to human perception
    Key([], "XF86MonBrightnessUp", lazy.spawn("xbacklight -perceived -inc 5"), desc="Increse brightness"),
    Key([], "XF86MonBrightnessDown", lazy.spawn("xbacklight -perceived -dec 5"), desc="Decrese brightness"),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("pamixer -i 5 --gamma 2"), desc="Increase volume"),
    Key([], "XF86AudioLowerVolume", lazy.spawn("pamixer -d 5 --gamma 2"), desc="Decrease volume"),
    Key([], "XF86AudioMute", lazy.spawn("pamixer -t"), desc="Toggle mute"),
    Key([], "Print", lazy.spawn("gnome-screenshot --area --interactive"), desc="Snipping tool"),
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front()),
]


for group in groups:
    keys.extend(
        [
            # mod1 + letter of group = switch to group
            Key(
                [mod],
                group.name,
                lazy.group[group.name].toscreen(),
                desc="Switch to group {}".format(group.name),
            ),
            # mod1 + shift + letter of group = switch to & move focused window to group
            Key(
                [mod, "shift"],
                group.name,
                lazy.window.togroup(group.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(group.name),
            ),
            # Or, use below if you prefer not to switch to that group.
            # # mod1 + shift + letter of group = move focused window to group
            # Key([mod, "shift"], i.name, lazy.window.togroup(i.name),
            #     desc="move focused window to group {}".format(i.name)),
        ]
    )
