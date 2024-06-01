import copy

from libqtile import bar, widget
from libqtile.config import Screen

from . import widgets as my_widgets
from .vars import Color, monitor_wallpaper

__all__ = ['screens']

size = 28
background = Color.transparent
margins = [2, 0, 2, 0]
bar_widgets = [
    widget.Spacer(length=5),
    my_widgets.EMPTY_LEFT,
    my_widgets.power_menu,
    my_widgets.EMPTY_RIGHT,
    widget.Spacer(length=10),
    my_widgets.EMPTY_LEFT,
    my_widgets.groupbox,
    my_widgets.EMPTY_RIGHT,
    widget.Spacer(),
    my_widgets.EMPTY_LEFT,
    my_widgets.date,
    my_widgets.time,
    my_widgets.EMPTY_RIGHT,
    widget.Spacer(),
    my_widgets.chord,
    widget.Spacer(length=10),
    my_widgets.EMPTY_LEFT,
    my_widgets.wifi,
    my_widgets.battery,
    my_widgets.volume,
    my_widgets.EMPTY_RIGHT,
    widget.Spacer(length=5),
]

screens = [
    Screen(
        wallpaper=monitor_wallpaper,
        wallpaper_mode='fill',
        top=bar.Bar(
            bar_widgets,
            size=size,
            background=background,
            margin=margins,
        ),
    ),
    Screen(
        wallpaper=monitor_wallpaper,
        wallpaper_mode='fill',
        top=bar.Bar(
            [(copy.copy(w) if w is my_widgets.groupbox else w) for w in bar_widgets],
            size=size,
            background=background,
            margin=margins,
        ),
    ),
]
