#!/usr/bin/env bash

# Useful for testing picom effects, run like this:
# ls ~/.config/picom/picom.conf | entr -p reload_picom.sh

while ! picom -b &>/dev/null; do
    killall picom
done
