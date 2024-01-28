#!/usr/bin/env bash

# Simple useful script for reloading dunst's and testing config
# Use it like this:
# $ ls path/to/dunstrc | entr -p ./reload_config

pkill dunst >/dev/null
notify-send --hint int:value:12 --urgency=low 'Test Title' 'This is the body.'
notify-send --hint int:value:52 --urgency=normal 'Test Title' 'This is the body.'
notify-send --hint int:value:100 --urgency=critical 'Test Error!!!' 'This is the body.'
notify-send --urgency=low 'Test Title' 'Without bar'
notify-send --app-name 'Notification' --urgency=normal 'Test Title' 'Without bar'
