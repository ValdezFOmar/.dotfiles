import re

from libqtile.config import Group, Match, Rule
from libqtile.dgroups import simple_key_binder

from .vars import mod, terminal

__all__ = ['groups', 'dgroups_key_binder', 'dgroups_app_rules']


dgroups_key_binder = simple_key_binder(mod, 'asdiop')
dgroups_app_rules: list[Rule] = []

groups = [
    Group(
        'browser',
        label='󰈹',
        matches=[Match(wm_class=re.compile('firefox', re.IGNORECASE))],
    ),
    Group('terminal', label='', spawn=terminal, layout='monadtall'),
    Group(
        'document',
        label='󱔗',
        matches=[
            Match(title=re.compile('libreoffice', re.IGNORECASE)),
            Match(wm_class=re.compile('libreoffice', re.IGNORECASE)),
            Match(wm_class=re.compile('[Ss]office')),
            Match(wm_class='Zotero'),
        ],
    ),
    Group('mail', label='󰻨', matches=[Match(wm_class='thunderbird')]),
    Group('misc-1', label=''),
    Group('misc-2', label=''),
]
