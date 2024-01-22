from __future__ import annotations

import re

from libqtile import hook, layout
from libqtile.backend.base import Static, Window
from libqtile.config import Group, Match, Rule

# from libqtile.dgroups import simple_key_binder
from libqtile.utils import send_notification

from .layouts import max_config
from .vars import mod, terminal

__all__ = ["groups", "dgroups_key_binder", "dgroups_app_rules"]


# As of version 0.23, simple_key_binder clutters the logs
dgroups_key_binder = None  # simple_key_binder(mod, "asdfuiop")
dgroups_app_rules: list[Rule] = [
    Rule(  # Windows that can be opened anywhere
        [
            Match(title=re.compile("screenshot", re.IGNORECASE)),
            Match(wm_class=re.compile("gpaste-ui", re.IGNORECASE)),
        ],
        float=True,
        intrusive=True,
    )
]

libreoffice_regex = re.compile("libreoffice", re.IGNORECASE)

groups = [
    Group(
        "a",
        label="󰈹",
        matches=[Match(wm_class=re.compile("firefox"))],
        exclusive=True,
        layouts=[layout.Max(**max_config)],
    ),
    Group("s", label="", spawn=terminal),
    Group(
        "d",
        label="󱔗",
        matches=[Match(title=libreoffice_regex), Match(wm_class=libreoffice_regex)],
        exclusive=True,
        layouts=[layout.Max(**max_config)],
    ),
    Group("f", label=""),
    Group("i", label=""),
    Group("o", label=""),
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
    new_group = window.group
    window.togroup(local_groups_names[-1])
    window.qtile.delgroup(new_group.name)
    send_notification("Qtile", f"Window {window.name!r} moved to group {window.group.name!r}")
