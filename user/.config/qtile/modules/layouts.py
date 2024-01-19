from libqtile import layout
from libqtile.config import Match

from .vars import Color

__all__ = ["layouts", "floating_layout"]

Config = dict[str, str | int | float]

layouts_config: Config = dict(
    margin=4,
    margin_on_single=False,
    border_width=2,
    border_normal=Color.dark,
    border_focus=Color.purple,
    border_on_single=False,
    # Monad layout specific
    ratio=0.55,
    single_margin=0,
    single_border_width=0,
)

layouts = [
    layout.MonadTall(**layouts_config),  # pyright: ignore
    layout.MonadWide(**layouts_config),  # pyright: ignore
]


floating_layout = layout.Floating(  # pyright: ignore
    border_width=1,
    border_focus=Color.light,
    border_normal=Color.literal_black,
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
