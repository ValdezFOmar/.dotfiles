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
import shutil
import subprocess as shell
import sys
from pathlib import Path

import utils

SYSTEM_CONFIG = utils.DOTFILES / "system"


def install_packages():
    shell.run(["/usr/bin/pacman", "-Syu"], check=True)
    with open(SYSTEM_CONFIG / "pkglist.txt", "r", encoding="utf-8") as file:
        packages = file.read()
    shell.run(["/usr/bin/pacman", "-S", "--needed", "-"], input=packages, encoding="utf-8", check=True)


def install_aur_packages():
    try:
        shell.run([f"/usr/bin/paru"], check=True)
    except FileNotFoundError:
        print(
            "`paru` executable not found",
            "Some packages from the AUR are needed, run the following commands to install paru:",
            "",
            "  git clone https://aur.archlinux.org/paru-bin.git",
            "  cd paru-bin",
            "  makepkg -si",
            "",
            "Then run `system-config --aur`",
            sep="\n",
            file=sys.stderr,
        )
        return

    with open(SYSTEM_CONFIG / "aur_pkglist.txt", "r", encoding="utf-8") as file:
        packages = file.read()
    shell.run(["/usr/bin/paru", "-S", "--needed", "-"], input=packages, encoding="utf-8", check=True)


def enable_services():
    services = [
        "lightdm",
        "NetworkManager",
        "cpupower",
    ]
    for service in services:
        shell.run(["/usr/bin/systemctl", "enable", f"{service}.service"])


def setup_reflector():
    shutil.copy(SYSTEM_CONFIG / "reflector.conf", "/etc/xdg/reflector")
    mirrorlist = Path("/etc/pacman.d/mirrorlist")
    mirrorlist_backup = mirrorlist.with_name(mirrorlist.name + "~")

    if not mirrorlist_backup.exists():
        shutil.copy(mirrorlist, mirrorlist_backup)

    shell.run(["/usr/bin/systemctl", "enable", "reflector.timer", "--now"])


def install_files():
    pacman_hooks = Path("/etc/pacman.d/hooks")
    pacman_hooks.mkdir(parents=True, exist_ok=True)
    shutil.copy(SYSTEM_CONFIG / "pkglist.hook", pacman_hooks)
    utils.handle_symlink(SYSTEM_CONFIG / "pkglist.txt", Path("/etc/pkglist.txt"))
    shutil.copy(SYSTEM_CONFIG / "aur_pkglist.hook", pacman_hooks)
    utils.handle_symlink(SYSTEM_CONFIG / "aur_pkglist.txt", Path("/etc/aur_pkglist.txt"))

    lightdm_path = Path("/etc/lightdm")
    lightdm_path.mkdir(parents=True, exist_ok=True)
    shutil.copy(SYSTEM_CONFIG / "slick-greeter.conf", lightdm_path)

    badges = Path("/usr/share/slick-greeter/badges")
    qtile_icon = Path(shutil.copy(SYSTEM_CONFIG / "qtile.png", badges))
    utils.handle_symlink(qtile_icon, badges / "qtile-wayland.png")


def main() -> int:
    parser = argparse.ArgumentParser(
        description="For installing system configurations (assumed to be running on Arch Linux).",
        epilog=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("--all", action="store_true", help="install everything")
    parser.add_argument("--files", action="store_true", help="copy/symlink system files")
    parser.add_argument("--aur", action="store_true", help="install AUR packages (uses paru)")
    args = parser.parse_args()

    if not any(vars(args).values()):
        parser.error("Please choose at least one option")

    if os.getuid() != 0:
        print("You need to run this script as root", file=sys.stderr)
        return 1

    if args.all:
        install_packages()
        enable_services()
        setup_reflector()
        install_files()
        install_aur_packages()
    else:
        if args.files:
            install_files()
        if args.aur:
            install_aur_packages()

    return 0


if __name__ == "__main__":
    sys.exit(main())
