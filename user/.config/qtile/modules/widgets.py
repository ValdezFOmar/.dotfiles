from libqtile import widget
from libqtile.lazy import lazy

from .vars import Color, frequency_menu

__all__ = ["widget_defaults", "extension_defaults"]

# Widgets
widget_defaults = dict(
    font="sans",
    fontsize=16,
    padding=6,
    foreground=Color.LIGHT_WHITE,
)
extension_defaults = widget_defaults.copy()

groupbox = widget.GroupBox(
    active=Color.WHITE,
    highlight_method="block",
    this_screen_border=Color.BLUE,
    this_current_screen_border=Color.BLUE,
    block_highlight_text_color=Color.BLACK,
    inactive=Color.LIGHT_BLACK,
    spacing=3,
)
# widget.Prompt()
chord = widget.Chord(
    chords_colors={
        "launch": (Color.RED, Color.WHITE),
        "tool": (Color.RED, Color.WHITE),
    },
    name_transform=lambda name: name.title(),
)
# NB Systray is incompatible with Wayland, consider using StatusNotifier instead
# widget.StatusNotifier()
# widget.Systray()
volume = widget.Volume(fmt="Vol: {}", foreground=Color.MAGENTA)
battery = widget.Battery(
    update_interval=1,  # seconds
    format="{char} {percent:2.0%}",
    discharge_char="B",
    low_foreground=Color.LIGHT_RED,
    low_percentage=0.2,
    foreground=Color.YELLOW,
    mouse_callbacks={"Button1": lazy.spawn(frequency_menu)},
)
date = widget.Clock(format="%A %d/%b/%Y", foreground=Color.LIGHT_BLUE)
time = widget.Clock(format="%I:%M %p", foreground=Color.GREEN)
