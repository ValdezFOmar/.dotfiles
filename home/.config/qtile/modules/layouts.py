import re

from libqtile import layout
from libqtile.config import Match

from .vars import Color

__all__ = ['layouts', 'floating_layout']

border_normal = Color.dark
border_focus = Color.blue  # Color.grayscale6

layouts_config = dict[str, object](
    margin=6,
    border_width=2,
    margin_on_single=False,
    border_on_single=False,
    border_normal=border_normal,
    border_focus=border_focus,
)

max_config = layouts_config.copy()
max_config.update(only_focused=True, border_width=0)

monad_config = layouts_config.copy()
monad_config.update(
    ratio=0.50,
    single_border_width=0,
    # single_margin=0,
)

layouts = [
    layout.Max(**max_config),
    layout.MonadTall(**monad_config),
]


# Use this command to get the window properties:
# $ xprop | grep '^WM_'
floating_layout = layout.Floating(
    border_width=2,
    border_focus=border_focus,
    border_normal=border_normal,
    float_rules=[
        *layout.Floating.default_float_rules,
        Match(wm_class='confirmreset'),  # gitk
        Match(wm_class='makebranch'),  # gitk
        Match(wm_class='maketag'),  # gitk
        Match(wm_class='ssh-askpass'),  # ssh-askpass
        Match(title='branchdialog'),  # gitk
        Match(title='pinentry'),  # GPG key password entry
        Match(title='V Bibliography Database', wm_class='libreoffice'),
        Match(wm_instance_class='Toplevel', wm_class='Zotero'),  # Zotero dialogs on LibreOffice
        Match(title='Library', wm_class='Places'),  # firefox downloads menu
        Match(wm_class='gnome-screenshot'),  # Preview screenshot window
        Match(title='Dear PyGui', wm_class='Dear PyGui'),
        Match(wm_class='Matplotlib'),
        Match(title=re.compile('(?!AntiMicroX)'), wm_class='antimicrox'),
        *[
            Match(wm_class=re.compile(regex, re.IGNORECASE))
            for regex in (
                'gpaste-ui',
                'nsxiv',
                'pcmanfm',
                'lxrandr',
                'arandr',
            )
        ],
        # Float all windows that are the child of a parent window
        Match(func=lambda c: bool(c.is_transient_for())),
    ],
)
