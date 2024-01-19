from libqtile import bar, widget
from libqtile.config import Screen

from . import widgets as mywidgets
from .vars import Color, monitor_wallpaper

__all__ = ["screens"]

screens = [
    Screen(
        wallpaper=monitor_wallpaper,
        wallpaper_mode="fill",
        top=bar.Bar(
            [
                widget.Spacer(length=5),
                mywidgets.EMPTY_LEFT,
                mywidgets.power_menu,
                mywidgets.EMPTY_RIGHT,
                widget.Spacer(length=10),
                mywidgets.EMPTY_LEFT,
                mywidgets.groupbox,
                mywidgets.EMPTY_RIGHT,
                widget.Spacer(),
                mywidgets.EMPTY_LEFT,
                mywidgets.date,
                mywidgets.time,
                mywidgets.EMPTY_RIGHT,
                widget.Spacer(),
                mywidgets.chord,
                widget.Spacer(length=10),
                mywidgets.EMPTY_LEFT,
                mywidgets.wifi,
                mywidgets.battery,
                mywidgets.volume,
                mywidgets.EMPTY_RIGHT,
                widget.Spacer(length=5),
            ],
            size=28,
            background=Color.transparent,
            margin=[2, 0, 2, 0],
        ),
    ),
]
