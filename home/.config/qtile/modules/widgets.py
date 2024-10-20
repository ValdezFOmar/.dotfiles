from __future__ import annotations

import socket
from typing import TYPE_CHECKING

from libqtile.lazy import lazy
from libqtile.widget.battery import BatteryState, BatteryStatus
from qtile_extras import widget
from qtile_extras.widget.decorations import RectDecoration

from . import vars
from .vars import Color

if TYPE_CHECKING:
    from collections.abc import Sequence

    from libqtile.utils import ColorsType

__all__ = ['widget_defaults', 'extension_defaults']

widget_defaults = dict(
    font=vars.monofont,
    fontsize=14,
    foreground=Color.text,
)
extension_defaults = widget_defaults.copy()


# See systemd.net-naming-scheme(7)
def get_wifi_interface() -> str | None:
    for _, interface in socket.if_nameindex():
        if interface.startswith('wl'):
            return interface


def clamp[T: (int, float)](lower: T, value: T, upper: T) -> T:
    return max(lower, min(value, upper))


class NerdFontBattery(widget.Battery):
    """A text icon battery, but displays Nerd Fonts' icons according to percentages."""

    low_percentage: float
    medium_percentage: float
    medium_background: ColorsType
    medium_foreground: ColorsType
    charge_icons: list[str]
    discharge_icons: list[str]
    format: str

    # Prevent clashing with Battery.defaults
    _defaults = [
        ('full_char', '󱟢', 'Character to indicate the battery is full'),
        ('empty_char', '󱃍', 'Character to indicate the battery is empty'),
        ('low_char', '󱃍', 'Character to indicate the battery is low'),
        ('unknown_char', '󰂑', 'Character to indicate the battery status is unknown'),
        ('not_charging_char', '󱟨', 'Character to indicate the batter is not charging'),
        ('charge_icons', ['󰢜', '󰂆', '󰂇', '󰂈', '󰢝', '󰂉', '󰢞', '󰂊', '󰂋', '󰂅'], 'Charge icon at percent X%'),
        ('discharge_icons', ['󰁺', '󰁻', '󰁼', '󰁽', '󰁾', '󰁿', '󰂀', '󰂁', '󰂂', '󰁹'], 'Icon at percent X%'),
        ('medium_foreground', '#FFFF00', 'Foreground color on medium battery'),
        ('medium_background', None, 'Background color on medium battery'),
        ('medium_percentage', 0.5, 'Indicates when to use the medium_foreground color (0 < x < 1)'),
    ]

    def __init__(self, **config: object) -> None:
        super().__init__(**config)
        self.add_defaults(self._defaults)

    def __update_colour(self, status: BatteryStatus) -> None:
        if self.layout is None:
            return
        if status.state is BatteryState.DISCHARGING:
            if status.percent <= self.low_percentage:
                self.layout.colour = self.low_foreground
                self.background = self.low_background
                return
            if status.percent <= self.medium_percentage:
                self.layout.colour = self.medium_foreground
                self.background = self.medium_background
                return
        self.layout.colour = self.foreground
        self.background = self.normal_background

    def __percent_to_icon(self, percent: float, icons: Sequence[str]) -> str:
        length = len(icons)
        index = int(clamp(0, percent, 1) * length)
        index = index if index < length else -1
        return icons[index]

    def build_string(self, status: BatteryStatus) -> str:
        self.__update_colour(status)
        char = ''

        match status.state:
            case BatteryState.FULL:
                char = self.full_char
            case BatteryState.EMPTY:
                char = self.empty_char
            case BatteryState.CHARGING:
                char = self.__percent_to_icon(status.percent, self.charge_icons)
            case BatteryState.DISCHARGING:
                if status.percent <= self.low_percentage:
                    char = self.low_char
                else:
                    char = self.__percent_to_icon(status.percent, self.discharge_icons)
            case BatteryState.UNKNOWN:
                char = self.unknown_char
            case BatteryState.NOT_CHARGING:
                char = self.not_charging_char

        percent_formated = clamp(0, int(status.percent * 100), 100)
        return self.format.format(char=char, percent=percent_formated)


class TitleClock(widget.Clock):
    def poll(self):
        return super().poll().title()


group_decoration = RectDecoration(
    colour=Color.darker,
    line_colour=Color.grayscale6,
    line_width=1.5,
    padding_y=2,
    radius=10,
    filled=True,
    group=True,
)

# Usefull for adding extra space to the sides of a group of widgets
EMPTY_LEFT = widget.TextBox(' ', padding=0, decorations=[group_decoration])
EMPTY_RIGHT = widget.TextBox(' ', padding=0, decorations=[group_decoration])

power_menu = widget.TextBox(
    ' <b>tile</b>',
    markup=True,
    mouse_callbacks={'Button1': lazy.spawn(vars.power_menu)},
    decorations=[group_decoration],
)

groupbox = widget.GroupBox(
    # There's a bug preventing the use of markup in this widget
    # fmt="<b>{}</b>",
    # markup=True,
    fontsize=14,
    highlight_method='text',
    active=Color.text,
    this_screen_border=Color.light_blue,
    this_current_screen_border=Color.light_blue,
    block_highlight_text_color=Color.literal_black,
    urgent_alert_method='text',
    urgent_text=Color.orange,
    inactive=Color.grayscale5,
    spacing=10,
    center_aligned=True,
    decorations=[group_decoration],
)

date = TitleClock(
    # format="<b>%A %d/%b/%Y</b> 󰃭 ", # Long format
    # Maybe implement it as a pop up?
    format='%A %d %B',
    fmt='<b>{}</b> 󰃭 ',
    markup=True,
    decorations=[group_decoration],
)

time = widget.Clock(
    format='<b>%I:%M</b>  ',
    markup=True,
    decorations=[group_decoration],
)

chord = widget.Chord(
    foreground=[Color.sky, Color.blue],
    name_transform=lambda name: f' {name.title()} ',
    decorations=[
        RectDecoration(
            colour=Color.darker,
            line_colour=[Color.sky, Color.blue],
            line_width=1.5,
            padding_y=2,
            radius=10,
            filled=True,
        ),
    ],
)

volume = widget.PulseVolume(
    fmt='<b>{}</b> ',
    foreground=Color.purple,
    mute_format='M 󰝟',
    unmute_format='{volume} 󰕾',
    markup=True,
    decorations=[group_decoration],
)

battery = NerdFontBattery(
    format='<b>{percent}</b> {char} ',
    markup=True,
    foreground=Color.blue,
    medium_foreground=Color.yellow,
    medium_percentage=0.5,
    low_foreground=Color.hot_red,
    low_percentage=0.2,
    update_interval=5,  # seconds
    notify_below=21,
    notification_timeout=30,
    decorations=[group_decoration],
)

# Check for interfaces with `nmcli device`
wifi = (
    widget.WiFiIcon(
        interface=interface,
        expanded_timeout=15,
        active_colour=Color.green,
        foreground=Color.green,
        fontsize=12,
        padding_y=7,
        decorations=[group_decoration],
    )
    if (interface := get_wifi_interface()) is not None
    else widget.TextBox(
        fmt='No wireless interface found',
        padding_y=7,
        foreground=Color.green,
        decorations=[group_decoration],
    )
)
