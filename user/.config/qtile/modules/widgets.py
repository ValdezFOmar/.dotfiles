from __future__ import annotations

from typing import TYPE_CHECKING

from libqtile.lazy import lazy
from libqtile.widget.battery import BatteryState, BatteryStatus
from qtile_extras import widget
from qtile_extras.widget.decorations import RectDecoration

from . import vars
from .vars import Color

if TYPE_CHECKING:
    from libqtile.utils import ColorsType

__all__ = ["widget_defaults", "extension_defaults"]

widget_defaults = dict(
    font=vars.monofont,
    fontsize=14,
    foreground=Color.text,
)
extension_defaults = widget_defaults.copy()


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
        ("full_char", "󱟢", "Character to indicate the battery is full"),
        ("empty_char", "󱃍", "Character to indicate the battery is empty"),
        ("low_char", "󱃍", "Character to indicate the battery is low"),
        ("unknown_char", "󰂑", "Character to indicate the battery status is unknown"),
        ("charge_icons", ["󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"], "Charge icon at percent X0%"),
        ("discharge_icons", ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"], "Icon at percent X0%"),
        ("medium_foreground", "#FFFF00", "Foreground color on medium battery"),
        ("medium_background", None, "Background color on medium battery"),
        ("medium_percentage", 0.5, "Indicates when to use the medium_foreground color 0 < x < 1"),
    ]

    def __init__(self, **config) -> None:
        super().__init__(**config)
        self.add_defaults(self._defaults)

    def _update_colour(self, status: BatteryStatus):
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

    def build_string(self, status: BatteryStatus) -> str:
        self._update_colour(status)

        percent = int(status.percent * 100)
        match status.state:
            case BatteryState.FULL:
                char = self.full_char
            case BatteryState.EMPTY:
                char = self.empty_char
            case BatteryState.CHARGING:
                char = self.charge_icons[percent // 10 - 1]
            case BatteryState.DISCHARGING:
                if status.percent <= self.low_percentage:
                    char = self.low_char
                else:
                    char = self.discharge_icons[percent // 10 - 1]
            case _:
                char = self.unknown_char

        return self.format.format(char=char, percent=percent)


class NerdFontVolume(widget.PulseVolume):
    """Like regular Volume, but uses NerdFonts' icons."""

    icon_list: list[str]
    format: str

    defualts = [
        (
            "format",
            "{volume}% {icon}",
            "The format to display the volume and icon",
        ),
        ("show_volume_when_mute", False, "Self explanatory"),
        ("mute_icon", "󰝟", "Icon to display when the mute"),
        ("no_volume_icon", "󰸈", "Icon to display when the volume is 0 and is not muted"),
        ("icon_list", ["󰕿", "󰖀", "󰕾"], "List of icons for low, medium and high volume, in order"),
    ]

    def __init__(self, **config):
        super().__init__(**config)
        self.add_defaults(self.defualts)

    def _update_drawer(self):
        if self.volume < 0:
            icon = self.mute_icon
        elif not self.volume:
            icon = self.no_volume_icon
        elif self.volume <= 20:
            icon = self.icon_list[0]
        elif self.volume < 70:
            icon = self.icon_list[1]
        else:
            icon = self.icon_list[2]

        volume = self.volume if icon != self.mute_icon else "M"
        self.text = self.format.format(icon=icon, volume=volume)


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
EMPTY_LEFT = widget.TextBox(" ", padding=0, decorations=[group_decoration])
EMPTY_RIGHT = widget.TextBox(" ", padding=0, decorations=[group_decoration])

power_menu = widget.TextBox(
    " <b>tile</b>",
    markup=True,
    mouse_callbacks={"Button1": lazy.spawn(vars.power_menu)},
    decorations=[group_decoration],
)

groupbox = widget.GroupBox(
    # There's a bug preventing the use of markup in this widget
    # fmt="<b>{}</b>",
    # markup=True,
    fontsize=14,
    highlight_method="text",
    active=Color.text,
    this_screen_border=Color.light_blue,
    this_current_screen_border=Color.light_blue,
    block_highlight_text_color=Color.literal_black,
    urgent_alert_method="text",
    urgent_text=Color.orange,
    inactive=Color.grayscale5,
    spacing=10,
    center_aligned=True,
    decorations=[group_decoration],
)

date = widget.Clock(
    # format="<b>%A %d/%b/%Y</b> 󰃭 ", # Long format
    # Maybe implement it as a pop up?
    format="<b>%A %d %b</b> 󰃭 ",
    markup=True,
    decorations=[group_decoration],
)

time = widget.Clock(
    format="<b>%I:%M</b>  ",
    markup=True,
    decorations=[group_decoration],
)

chord = widget.Chord(
    foreground=[Color.sky, Color.blue],
    name_transform=lambda name: f" {name.title()} ",
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

volume = NerdFontVolume(
    format="<b>{volume}</b> {icon} ",
    foreground=Color.purple,
    markup=True,
    decorations=[group_decoration],
)

battery = NerdFontBattery(
    format="<b>{percent}</b> {char} ",
    markup=True,
    foreground=Color.blue,
    medium_foreground=Color.yellow,
    medium_percentage=0.5,
    low_foreground=Color.hot_red,
    low_percentage=0.2,
    update_interval=1,  # seconds
    mouse_callbacks={"Button1": lazy.spawn(vars.frequency_menu)},
    notify_below=21,
    notification_timeout=30,
    decorations=[group_decoration],
)

# Check interface with `iwconfig`
wifi = widget.WiFiIcon(
    interface="wlo1",
    expanded_timeout=15,
    active_colour=Color.green,
    foreground=Color.green,
    fontsize=12,
    padding_y=7,
    decorations=[group_decoration],
)
