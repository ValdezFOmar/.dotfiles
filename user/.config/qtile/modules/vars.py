import os


class Color:
    LITERAL_BLACK = "#000000"
    BLACK = "#1b1d1e"
    LIGHT_BLACK = "#505354"
    RED = "#f92672"
    LIGHT_RED = "#ff669d"
    GREEN = "#a6e22e"
    LIGHT_GREEN = "#beed5f"
    YELLOW = "#fd971f"
    LIGHT_YELLOW = "#e6db74"
    BLUE = "#1989EB"
    LIGHT_BLUE = "#66d9ef"
    MAGENTA = "#9e6ffe"
    LIGHT_MAGENTA = "#66d9ef"
    CYAN = "#5e7175"
    LIGHT_CYAN = "#a3babf"
    WHITE = "#ccccc6"
    LIGHT_WHITE = "#f8f8f2"


monitor_wallpaper = "/usr/share/backgrounds/archlinux/archwave.png"

# Mod keys
alt = "mod1"
mod = "mod4"

# Programs
terminal = "kitty"
file_explorer = "pcmanfm"
menu_launcher = "rofi -show drun"

# Paths
local_bin = os.path.expanduser("~/.local/bin")
power_menu = os.path.join(local_bin, "powermenu")
frequency_menu = os.path.join(local_bin, "frequencymenu")
