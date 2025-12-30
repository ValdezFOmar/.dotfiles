#!/usr/bin/bash

if [[ $EUID -ne 0 ]]; then
    echo 'This script is intended to only be run as root'
    exit 1
fi

# Exit on errors
set -o errexit
set -o nounset
set -o pipefail

# Print commands as they are executed
set -o xtrace

backup-install() {
    install --backup=numbered -D --mode=644 "$1" "$2"
}

dir=$(dirname "$(realpath "$0")")

# greetd and nwg-hello
backup-install "$dir/greeter/greetd.conf" /etc/greetd/greetd.conf
backup-install "$dir/greeter/nwg-hello.css" /etc/nwg-hello/nwg-hello.css
backup-install "$dir/greeter/wallpaper.png" /usr/share/nwg-hello/wallpaper.png

# reflector
backup-install /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist-backup
backup-install "$dir/reflector.conf" /etc/xdg/reflector/reflector.conf

# Enable services
systemctl enable \
    NetworkManager.service \
    cpupower.service \
    greetd.service \
    paccache.timer \
    reflector.timer
