import re

from libqtile import hook, layout
from libqtile.backend.base import Static, Window
from libqtile.config import Group, Match, Rule
from libqtile.dgroups import simple_key_binder
from libqtile.utils import send_notification

from .layouts import max_config
from .vars import mod, terminal

__all__ = ["groups", "dgroups_key_binder", "dgroups_app_rules"]


dgroups_key_binder = simple_key_binder(mod, "asdiop")
dgroups_app_rules: list[Rule] = [
    Rule(  # Windows that can be opened anywhere
        [
            Match(wm_class=regex)
            for regex in (
                re.compile("gnome-screenshot", re.IGNORECASE),
                re.compile("gpaste-ui", re.IGNORECASE),
                re.compile("nsxiv", re.IGNORECASE),
                re.compile("pcmanfm", re.IGNORECASE),
            )
        ],
        float=True,
        intrusive=True,
    ),
]

libreoffice_regex = re.compile("libreoffice", re.IGNORECASE)

groups = [
    Group(
        "browser",
        label="󰈹",
        matches=[Match(wm_class=re.compile("firefox", re.IGNORECASE))],
        exclusive=True,
        layouts=[layout.Max(**max_config)],
    ),
    Group("terminal", label="", spawn=terminal),
    Group(
        "document",
        label="󱔗",
        matches=[Match(title=libreoffice_regex), Match(wm_class=libreoffice_regex)],
        exclusive=True,
        layouts=[layout.Max(**max_config)],
    ),
    Group("misc-1", label=""),
    Group("misc-2", label=""),
    Group("misc-3", label=""),
]

local_groups_names = tuple(g.name for g in groups)


@hook.subscribe.client_managed
def to_last_when_exclusive(window: Window):
    """
    When trying to open a window in an exclusive group that doesn't match,
    move the window to the last group instead of creating a new one.
    """
    if isinstance(window, Static):
        return
    assert window.group is not None
    if window.group.name in local_groups_names:
        return
    window.qtile.delgroup(window.group.name)
    seconds = 5 * 1000
    send_notification(
        "Qtile", f"Window {window.name!r} moved to group {window.group.name!r}", timeout=seconds
    )
