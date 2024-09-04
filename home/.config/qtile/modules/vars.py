import os


class Color:
    pink = '#f2a7de'
    purple = '#9e6ffe'
    hot_pink = '#f92672'
    hot_red = '#ff669d'
    red = '#ea7183'
    light_red = '#ea838c'
    orange = '#f39967'
    yellow = '#eaca89'
    green = '#96d382'
    sky = '#91d7e3'
    light_blue = '#68bae0'
    blue = '#739df2'
    lavender = '#a0a8f6'
    light = '#c7d2f2'
    text = '#b5c1f1'
    grayscale1 = '#a6b0d8'
    grayscale2 = '#959ec2'
    grayscale3 = '#848cad'
    grayscale4 = '#717997'
    grayscale5 = '#63677f'
    grayscale6 = '#505469'
    grayscale7 = '#3e4255'
    grayscale8 = '#2c2f40'
    dark = '#1b1d1e'
    darker = '#0b0d0e'
    literal_black = '#000000'
    transparent = '#00000000'


# GUI
# source: https://wallhaven.cc/w/769yk3
monitor_wallpaper = '~/.config/qtile/wallpaper.jpg'
guifont = 'sans'
monofont = 'CaskaydiaCove NF'

# Mod keys
alt = 'mod1'
mod = 'mod4'

# Programs
terminal = 'kitty'
file_explorer = 'pcmanfm'
menu_launcher = 'rofi -show drun'

# Paths
qtile_log = os.path.expanduser('~/.local/share/qtile/qtile.log')
local_bin = os.path.expanduser('~/bin')
power_menu = os.path.join(local_bin, 'powermenu')
frequency_menu = os.path.join(local_bin, 'frequencymenu')
notify_volume = os.path.join(local_bin, 'volume-notify')
toggle_touchpad = os.path.join(local_bin, 'toggle-touchpad-tapping')
