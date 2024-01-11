#!/usr/bin/bash

# Arch linux system configurration
# You need to run this script as root
#
# option:
#   --files   will only copy system configuration files and nothing else.


__file__="$(readlink --canonicalize "${BASH_SOURCE[0]}")"
dotfiles=$(dirname "$(dirname "$__file__")")
system_config="$dotfiles/system"

slick-greeter-config() {
    # NOTE: NO longer use since now the files is copied directly in the destination

    # Snippet taken from:
    # https://github.com/prikhi/lightdm-mini-greeter#config-file-in-home

    # This snippet allows the lightdm greeter config file to be in the home
    # directory and let lightdm read it so it can be properly setup

    usermod -aG "$(whoami)" lightdm
    chmod g+rx ~
    ln -s ~/.dotfiles/slick-greeter.conf /etc/lightdm/slick-greeter.conf
}

cp_files()
{
    set +s

    # Aditional files
    mkdir --parents /etc/pacman.d/hooks/
    mkdir --parents /etc/lightdm/

    cp --interactive -t /etc/pacman.d/hooks/ "$system_config/pkglist.hook"
    cp --interactive -t /etc/lightdm/ "$system_config/slick-greeter.conf"
    ln --interactive --symbolic "$system_config/pkglist.txt" /etc/
}

main()
{
    if (( EUID != 0 )); then
        echo "This file needs to be run as root."
        return 1
    fi

    if [[ "$1" = "--files" ]]; then
        cp_files
        return 0
    elif [ -n "$1" ]; then
        name=$(basename "$__file__")
        echo "$name: invalid option '$1'"
        return 1
    fi

    set -e

    # Install system packages
    pacman -Syu && pacman -S --needed - < "$system_config/pkglist.txt"

    # enabling services
    systemctl enable lightdm.service
    systemctl enable NetworkManager.service
    systemctl enable cpupower.service

    cp_files

}

main "$@"
