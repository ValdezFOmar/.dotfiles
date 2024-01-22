from libqtile.config import Click, Drag, Key, KeyChord
from libqtile.lazy import lazy

from . import vars
from .groups import groups
from .vars import alt, mod

__all__ = ["keys", "mouse"]

# TODO: Change keybinds to this more concise format
# https://github.com/numirias/qtile-plasma/blob/4b57f313ed6948212582de05205a3ae4372ed812/README.md?plain=1#L51
keys = [
    Key([mod], "h", lazy.layout.left(), desc="Move focus to left"),
    Key([mod], "l", lazy.layout.right(), desc="Move focus to right"),
    Key([mod], "j", lazy.layout.down(), desc="Move focus down"),
    Key([mod], "k", lazy.layout.up(), desc="Move focus up"),
    Key([mod], "space", lazy.layout.next(), desc="Move window focus to other window"),
    Key([mod, "shift"], "h", lazy.layout.shuffle_left(), desc="Move window to the left"),
    Key([mod, "shift"], "l", lazy.layout.shuffle_right(), desc="Move window to the right"),
    Key([mod, "shift"], "j", lazy.layout.shuffle_down(), desc="Move window down"),
    Key([mod, "shift"], "k", lazy.layout.shuffle_up(), desc="Move window up"),
    Key([mod], "n", lazy.layout.normalize(), desc="Reset all window sizes"),
    Key([mod], "w", lazy.window.kill(), desc="Kill focused window"),
    Key([mod, "control"], "r", lazy.reload_config(), desc="Reload the config"),
    Key([mod], "Tab", lazy.next_layout(), desc="Toggle between layouts"),
    Key([mod], "Left", lazy.screen.prev_group(), desc="Go to previous group"),
    Key([mod], "Right", lazy.screen.next_group(), desc="Go to next group"),
    # Custom keybinds
    Key([mod], "Return", lazy.spawn(vars.terminal), desc="Launch terminal"),
    Key([mod, alt], "f", lazy.window.toggle_floating(), desc="Switch between float and tiling window"),
    Key([mod, alt], "m", lazy.window.toggle_floating(), desc="Toggle fullscreen tiling window"),
    Key([mod], "b", lazy.spawn("firefox"), desc="Launch firefox browser"),
    Key([mod, alt], "b", lazy.spawn("firefox -P School"), desc="Launch firefox browser with school profile"),
    Key([mod], "e", lazy.spawn(vars.file_explorer), desc="Launch a file explorer"),
    Key([mod], "q", lazy.spawn(vars.power_menu), desc="Launch power menu"),
    Key([mod], "m", lazy.spawn(vars.menu_launcher), desc="Open menu launcher for programs"),
    KeyChord(
        [mod],
        "t",
        [
            Key(
                [], "p", lazy.spawn("xcolor --format HEX --preview-size 155 --selection"), desc="Color picker"
            ),
            Key([], "h", lazy.spawn("gpaste-client ui"), desc="Clipboard history"),
            Key(
                [],
                "l",
                lazy.spawn(f"{vars.terminal} less +F -S {vars.qtile_log}"),
                desc="Open Qtile log file",
            ),
        ],
        name="tool",
        desc="Tooling (mod + T + <key>), for using general purpose tools",
    ),
    # Hardware Keybinds
    # Note: Both volume and backlight are configure to be more accurate to human perception
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


# TODO: remove once the logs bug is solved
# TODO: Maybe move the simple_keybinder to here instead?
for group in groups:
    keys.extend(
        [
            Key(
                [mod],
                group.name,
                lazy.group[group.name].toscreen(),
                desc="Switch to group {}".format(group.name),
            ),
            # mod1 + shift + group number = switch to & move focused window to group
            Key(
                [mod, "shift"],
                group.name,
                lazy.window.togroup(group.name, switch_group=True),
                desc="Switch to & move focused window to group {}".format(group.name),
            ),
        ]
    )
