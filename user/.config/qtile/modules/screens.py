from libqtile import bar, widget
from libqtile.config import Screen

from . import widgets as mywidgets
from .vars import Color, monitor_wallpaper

__all__ = ["screens"]


screens = [
    Screen(
        wallpaper=monitor_wallpaper,
        wallpaper_mode="fill",
        bottom=bar.Bar(
            [
                widget.CurrentLayoutIcon(scale=0.8),
                mywidgets.groupbox,
                widget.WindowName(),
                mywidgets.chord,
                mywidgets.volume,
                mywidgets.battery,
                mywidgets.date,
                mywidgets.time,
            ],
            28,
            # border_width=[0, 0, 0, 0],  # top, right, bottom, left
            # border_color=["", "", "", ",
            background=Color.BLACK,
        ),
    ),
    Screen(
        wallpaper=monitor_wallpaper,
        wallpaper_mode="fill",
        bottom=bar.Bar(
            [
                widget.CurrentLayoutIcon(scale=0.8),
                mywidgets.groupbox.clone(),
                widget.WindowName(),
                mywidgets.chord.clone(),
                mywidgets.volume,
                mywidgets.battery,
                mywidgets.date,
                mywidgets.time,
            ],
            28,
            background=Color.BLACK,
        ),
    ),
]
