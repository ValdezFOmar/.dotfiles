#!/usr/bin/env python3

"""
For installing system configurration (assumed to be running on Arch Linux).

Requirements:
- python >=3.11

This script takes care of:
- Downloading all the necessary packages using pacman.
- Copying system configuration files.

NOTE: This script needs to be run as root
"""

import argparse
import os
import shutil
import subprocess as shell
import sys
from pathlib import Path

import utils

SYSTEM_CONFIG = utils.DOTFILES / "system"


def install_packages():
    shell.run(["pacman", "-Syu"], check=True)
    with open(SYSTEM_CONFIG / "pkglist.txt", "r", encoding="utf-8") as file:
        packages = file.read()
    shell.run(["pacman", "-S", "--needed", "-"], input=packages, encoding="utf-8", check=True)


def enable_services():
    services = [
        "lightdm",
        "NetworkManager",
        "cpupower",
    ]
    for service in services:
        shell.run(["systemctl", "enable", f"{service}.service"])


def install_files():
    pacman_hooks = Path("/etc/pacman.d/hooks")
    pacman_hooks.mkdir(parents=True, exist_ok=True)
    shutil.copy(SYSTEM_CONFIG / "pkglist.hook", pacman_hooks)
    utils.handle_symlink(SYSTEM_CONFIG / "pkglist.txt", Path("/etc/pkglist.txt"))

    lightdm_path = Path("/etc/lightdm")
    lightdm_path.mkdir(parents=True, exist_ok=True)
    shutil.copy(SYSTEM_CONFIG / "slick-greeter.conf", lightdm_path)

    badges = Path("/usr/share/slick-greeter/badges")
    qtile_icon = Path(shutil.copy(SYSTEM_CONFIG / "qtile.png", badges))
    utils.handle_symlink(qtile_icon, badges / "qtile-wayland.png")


# TODO: Add setup for mirror list (package reflector)
#   https://wiki.archlinux.org/title/Reflector
def main() -> int:
    parser = argparse.ArgumentParser(description="Install system configuration/settoings files.")
    parser.add_argument("--all", action="store_true", help="install everything")
    parser.add_argument("--files", action="store_true", help="copy/symlink system files")
    args = parser.parse_args()

    if not any(vars(args).values()):
        parser.error("Please choose at least one option")

    if os.getuid() != 0:
        print("You need to run this script as root", file=sys.stderr)
        return 1

    if args.all:
        install_packages()
        enable_services()
        install_files()
    elif args.files:
        install_files()

    return 0


if __name__ == "__main__":
    sys.exit(main())
