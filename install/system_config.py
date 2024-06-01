#!/usr/bin/env python3

"""
This script takes care of:
- Downloading all the necessary packages using pacman.
- Copying system configuration files.
- Enabling system services.

NOTE: This script needs to be run as root
"""

import argparse
import os
import subprocess as subp
import sys
from pathlib import Path

from install import utils

SYSTEM_CONFIG = utils.DOTFILES / 'system'


def install_packages():
    subp.run(['/usr/bin/pacman', '-Syu'], check=True)
    with open(SYSTEM_CONFIG / 'pkglist.txt', 'r', encoding='utf-8') as file:
        packages = file.read()
    subp.run(['/usr/bin/pacman', '-S', '--needed', '-'], input=packages, encoding='utf-8', check=True)


def enable_services():
    services = [
        'lightdm.service',
        'NetworkManager.service',
        'cpupower.service',
        'paccache.timer',
    ]
    for service in services:
        subp.run(['/usr/bin/systemctl', 'enable', service])


def setup_reflector(manager: utils.FilesManager) -> None:
    manager.copy_file(SYSTEM_CONFIG / 'reflector.conf', Path('/etc/xdg/reflector'))
    mirrorlist = Path('/etc/pacman.d/mirrorlist')
    mirrorlist_backup = mirrorlist.with_name(mirrorlist.name + '~')

    if not mirrorlist_backup.exists():
        manager.copy_file(mirrorlist, mirrorlist_backup)

    subp.run(['/usr/bin/systemctl', 'enable', 'reflector.timer', '--now'])


def install_files(manager: utils.FilesManager) -> None:
    pacman_hooks = Path('/etc/pacman.d/hooks')
    if manager.create_directory(pacman_hooks):
        manager.copy_file(SYSTEM_CONFIG / 'pkglist.hook', pacman_hooks)
        manager.copy_file(SYSTEM_CONFIG / 'aur_pkglist.hook', pacman_hooks)
    manager.handle_symlink(SYSTEM_CONFIG / 'pkglist.txt', Path('/etc/pkglist.txt'))
    manager.handle_symlink(SYSTEM_CONFIG / 'aur_pkglist.txt', Path('/etc/aur_pkglist.txt'))

    lightdm_path = Path('/etc/lightdm')
    if manager.create_directory(lightdm_path):
        manager.copy_file(SYSTEM_CONFIG / 'slick-greeter.conf', lightdm_path)

    badges = Path('/usr/share/slick-greeter/badges')
    qtile_icon = manager.copy_file(SYSTEM_CONFIG / 'qtile.png', badges)
    manager.handle_symlink(qtile_icon, badges / 'qtile-wayland.png')


def main() -> int:
    parser = argparse.ArgumentParser(
        description='For installing system configurations (assumed to be running on Arch Linux).',
        epilog=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument('--all', action='store_true', help='install everything')
    parser.add_argument('--files', action='store_true', help='copy/symlink system files')
    args = parser.parse_args()

    if not any(vars(args).values()):
        parser.error('Please choose at least one option')

    if os.getuid() != 0:
        print('You need to run this script as root', file=sys.stderr)
        return 1

    manager = utils.FilesManager()

    if args.all:
        install_packages()
        enable_services()
        setup_reflector(manager)
        install_files(manager)
    elif args.files:
        install_files(manager)

    manager.print_summary()
    return 0


if __name__ == '__main__':
    sys.exit(main())
