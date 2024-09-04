#!/usr/bin/bash

set -e

if [[ $EUID -ne 0 ]]; then
    echo 'This script is intended to only be run as root'
    exit 1
fi

etc_dir=$(dirname "$(realpath "$0")")

# slick-greeter
badges_dir=/usr/share/slick-greeter/badges

command cp --verbose --backup=numbered "$etc_dir/slick-greeter.conf" /etc/lightdm
command cp --verbose "$etc_dir/qtile.png" "$badges_dir"
ln --verbose --symbolic --force qtile.png "$badges_dir/qtile-wayland.png"
unset badges_dir

# reflector
command cp --verbose --backup=numbered "$etc_dir/reflector.conf" /etc/xdg/reflector

mirrorlist=/etc/pacman.d/mirrorlist
[[ -f $mirrorlist.bak ]] || cp "$mirrorlist" "$mirrorlist.bak"
unset mirrorlist

# Enable services
systemctl enable \
    NetworkManager.service \
    cpupower.service \
    lightdm.service \
    paccache.timer \
    reflector.timer
