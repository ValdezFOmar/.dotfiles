# TODO:
# - Improve look and functionality
#   - See https://qtile.org/screenshots/ for ideas
# - Check documentation https://docs.qtile.org/en/stable/

from modules.groups import *
from modules.keybinds import *
from modules.layouts import *
from modules.screens import *
from modules.widgets import *

dgroups_key_binder = None
dgroups_app_rules = []  # type: list
follow_mouse_focus = True
bring_front_click = "floating_only"
cursor_warp = False
auto_fullscreen = True
focus_on_window_activation = "smart"
reconfigure_screens = True
auto_minimize = True
wl_input_rules = None
wmname = "LG3D"
