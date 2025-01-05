from typing import TYPE_CHECKING, NamedTuple

from libqtile.config import Click, Drag, EzKey, EzKeyChord
from libqtile.lazy import LazyCall, lazy

from . import vars
from .vars import mod

__all__ = ['keys', 'mouse']

if TYPE_CHECKING:
    from collections.abc import Sequence


type KeyAction = tuple[LazyCall, str] | tuple[Sequence[LazyCall], str] | KeyChordAction
type KeyMappings = dict[str, KeyAction]


class KeyChordAction(NamedTuple):
    name: str
    desc: str
    mappings: KeyMappings


def to_ezkey(key: str, action: KeyAction) -> EzKey | EzKeyChord:
    match action:
        case KeyChordAction(name, desc, mappings):
            return EzKeyChord(
                key,
                [to_ezkey(key, action) for key, action in mappings.items()],
                name=name,
                desc=desc,
            )
        case ([*commands], desc):
            return EzKey(key, *commands, desc=desc)
        case (command, desc):
            return EzKey(key, command, desc=desc)


cmd = lazy.spawn
no_fullscreen = lazy.window.disable_fullscreen


keybinds: KeyMappings = {
    'M-C-r': (lazy.reload_config(), 'Reload the config'),
    # Move window focus
    'M-<space>': ([no_fullscreen(), lazy.layout.next()], 'Move window focus to the next window'),
    'M-h': ([no_fullscreen(), lazy.layout.left()], 'Move focus to left'),
    'M-l': ([no_fullscreen(), lazy.layout.right()], 'Move focus to right'),
    'M-j': ([no_fullscreen(), lazy.layout.down()], 'Move focus down'),
    'M-k': ([no_fullscreen(), lazy.layout.up()], 'Move focus up'),
    # Change window placement
    'M-S-h': (lazy.layout.shuffle_left(), 'Move window to the left'),
    'M-S-l': (lazy.layout.shuffle_right(), 'Move window to the right'),
    'M-S-j': (lazy.layout.shuffle_down(), 'Move window down'),
    'M-S-k': (lazy.layout.shuffle_up(), 'Move window up'),
    # Operations on windows / other
    'M-w': (lazy.window.kill(), 'Kill focused window'),
    'M-n': (lazy.layout.normalize(), 'Reset all window sizes'),
    'M-f': (lazy.window.toggle_floating(), 'Switch between float and tiling window'),
    'M-A-f': (lazy.window.toggle_fullscreen(), 'Toggle fullscreen window'),
    'M-<Tab>': (lazy.next_layout(), 'Toggle between layouts'),
    'M-<Left>': (lazy.screen.prev_group(), 'Go to previous group'),
    'M-<Right>': (lazy.screen.next_group(), 'Go to next group'),
    # Special
    '<Print>': (cmd('gnome-screenshot --clipboard'), 'Screenshot'),
    'A-<Print>': (cmd('gnome-screenshot --window --clipboard'), 'Screenshot current window'),
    'C-<Print>': (cmd('gnome-screenshot --area --delay=1 --clipboard'), 'Snipping tool'),
    # Hardware keys
    # Note: Both volume and backlight are configure to be more accurate to human perception
    '<XF86MonBrightnessUp>': (cmd('xbacklight -perceived -inc 5'), 'Increse brightness'),
    '<XF86MonBrightnessDown>': (cmd('xbacklight -perceived -dec 5'), 'Decrese brightness'),
    '<XF86AudioRaiseVolume>': ([cmd('pamixer -i 5 --gamma 2'), cmd(vars.notify_volume)], 'Increase volume'),
    '<XF86AudioLowerVolume>': ([cmd('pamixer -d 5 --gamma 2'), cmd(vars.notify_volume)], 'Decrease volume'),
    '<XF86AudioMute>': ([cmd('pamixer --toggle-mute'), cmd(vars.notify_volume)], 'Toggle mute'),
    # Programs / Applications
    'M-<Return>': (cmd(vars.terminal), 'Launch terminal'),
    'M-b': (cmd('firefox'), 'Launch firefox browser'),
    'M-A-b': (cmd('firefox -P School'), 'Launch firefox browser with school profile'),
    'M-e': (cmd(vars.file_explorer), 'Launch a file explorer'),
    'M-q': (cmd(vars.power_menu), 'Launch power menu'),
    'M-m': (cmd(vars.menu_launcher), 'Open menu launcher for programs'),
    # Chords
    'M-t': KeyChordAction(
        name='tool',
        desc='Tooling (mod + T + <key>), for using general purpose tools',
        mappings={
            'p': (cmd('xcolor --format HEX --preview-size 155 --selection clipboard'), 'Color picker'),
            'h': (cmd('gpaste-client ui'), 'Clipboard history'),
            'l': (cmd(f'{vars.terminal} less +F -S {vars.qtile_log}'), 'Open Qtile log file'),
            't': (cmd(vars.toggle_touchpad), 'Enbale/Disable touchpad tapping'),
        },
    ),
}


keys = [to_ezkey(key, action) for key, action in keybinds.items()]

# Drag floating layouts.
# TODO: Use EzDrag and EzClick?
mouse = [
    Drag([mod], 'Button1', lazy.window.set_position_floating(), start=lazy.window.get_position()),
    Drag([mod], 'Button3', lazy.window.set_size_floating(), start=lazy.window.get_size()),
    Click([mod], 'Button2', lazy.window.bring_to_front()),
]
