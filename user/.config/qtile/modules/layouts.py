from libqtile import layout
from libqtile.config import Match

from .vars import Color

__all__ = ["layouts", "floating_layout"]

border_normal = Color.dark
border_focus = Color.grayscale6

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
    ratio=0.55,
    single_border_width=0,
    # single_margin=0,
)

layouts = [
    layout.MonadTall(**monad_config),
    # layout.MonadWide(**monad_config),
]


floating_layout = layout.Floating(
    border_width=2,
    border_focus=border_focus,
    border_normal=border_normal,
    float_rules=[
        # Run the utility of `xprop` to see the wm class and name of an X client.
        *layout.Floating.default_float_rules,  # pyright: ignore
        Match(wm_class="confirmreset"),  # gitk
        Match(wm_class="makebranch"),  # gitk
        Match(wm_class="maketag"),  # gitk
        Match(wm_class="ssh-askpass"),  # ssh-askpass
        Match(title="branchdialog"),  # gitk
        Match(title="pinentry"),  # GPG key password entry
        Match(title="V Bibliography Database", wm_class="libreoffice"),
        Match(wm_instance_class="Toplevel", wm_class="Zotero"),  # Zotero dialogs on LibreOffice
        Match(title="Library", wm_class="Places"),  # firefox downloads menu
        Match(title="nsxiv", wm_class="float"),
        Match(title="Dear PyGui", wm_class="Dear PyGui"),
        Match(wm_class="gnome-screenshot"),  # Preview screenshot window
        # Float all windows that are the child of a parent window
        # Match(func=lambda c: bool(c.is_transient_for())),
    ],
)
