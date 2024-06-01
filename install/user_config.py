#!/usr/bin/env python3

"""
This script takes care of:
 - Creating the appropiate symbolic links for diferent config files.
 - Setting the defualt theme.
 - Creating some special and useful directories.

While the script can override files and empty directories, it will not attempt
to remove non-empty directories, skiping them instead.

Requirements:
 - git

WARNING: This script should NOT be run as root.
"""

import argparse
import shutil
import subprocess as subp
import sys
from pathlib import Path

from install import utils
from install.system_config import SYSTEM_CONFIG

USER_CONFIG = utils.DOTFILES / 'user'

SPECIAL_DIRS = [
    Path.home() / directory
    for directory in {
        'projects',
        'archives',
        'bin',
        'builds',
        'Documents',
        'Downloads',
        'Images',
        'repos',
        'Screenshots',
    }
]


def set_keyboard_layout():
    """X11 persistent keyboard layout."""
    subp.run(['/usr/bin/localectl', 'set-x11-keymap', 'latam'], stdout=subp.DEVNULL)


def enable_user_services():
    subp.run(['/usr/bin/systemctl', '--user', 'enable', 'tldr-cache.timer'])


def git_config():
    home = Path.home()
    completion = Path('/usr/share/git/completion/git-completion.bash')
    if completion.exists():
        shutil.copy(completion, home / f".{completion.name}")

    prompt = Path('/usr/share/git/completion/git-prompt.sh')
    if prompt.exists():
        shutil.copy(prompt, home / f".{prompt.name}")


def install_aur_packages():
    try:
        with open(SYSTEM_CONFIG / 'aur_pkglist.txt', 'r', encoding='utf-8') as file:
            packages = file.read()
        subp.run(['/usr/bin/paru', '-S', '--needed', '-'], input=packages, encoding='utf-8', check=True)
    except FileNotFoundError:
        print(
            """\
`paru` executable not found.
Some packages from the AUR are needed, run the following commands to install paru:

git clone https://aur.archlinux.org/paru-bin.git
cd paru-bin
makepkg -si

Then run `system-config --aur`
""",
            file=sys.stderr,
        )
        return


def main() -> int:
    parser = argparse.ArgumentParser(
        description='For installing user related configuration files.',
        epilog=__doc__,
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument('--all', action='store_true', help='install everything')
    parser.add_argument('--nvim', action='store_true', help='install Neovim configuration')
    parser.add_argument('--config', action='store_true', help="install '.config/' configurations")
    parser.add_argument('--home', action='store_true', help="install '~/' configurations")
    parser.add_argument('--scripts', action='store_true', help='install local scripts')
    parser.add_argument('--theme', action='store_true', help='install GUI theme')
    parser.add_argument('--aur', action='store_true', help='install AUR packages (uses paru)')
    args = parser.parse_args()

    if not any(vars(args).values()):
        parser.error('Please choose at least one option')

    manager = utils.FilesManager()

    if args.all:
        for attr in vars(args):
            setattr(args, attr, True)
        for directory in SPECIAL_DIRS:
            manager.create_directory(directory)
        set_keyboard_layout()
        enable_user_services()
    if args.config:
        manager.symlink_contents(USER_CONFIG / '.config', use_dir_name=True)
    if args.nvim and not args.config:
        xdg_config = Path.home() / '.config'
        xdg_config.mkdir(exist_ok=True)
        manager.handle_symlink(USER_CONFIG / '.config' / 'nvim', xdg_config / 'nvim')
    if args.home:
        manager.symlink_contents(USER_CONFIG / 'home', Path.home())
        git_config()
    if args.scripts:
        manager.symlink_contents(USER_CONFIG / '.local', use_dir_name=True)
    if args.theme:
        default_icons = Path('.icons', 'default')
        manager.symlink_contents(USER_CONFIG / default_icons, Path.home() / default_icons)
    if args.aur:
        install_aur_packages()

    manager.print_summary()

    return 0


if __name__ == '__main__':
    sys.exit(main())
