#!/usr/bin/env python3

"""
For installing user related configuration files.

Requirements:
- git
- python >=3.11

This script takes care of:
- Creating the appropiate symbolic links for diferent config files.
- Downloading any additional packages not found in the arch linux repositories.
- Setting the defualt theme.
- Creating some special and useful directories.

While the script can override files and empty directories, it will not attempt
to remove non-empty directories, skiping them instead.

WARNING: This script should NOT be run as root.
"""

import argparse
import shutil
import subprocess as shell
import sys
from pathlib import Path

from utils import DOTFILES, handle_symlink, symlink_config

USER_CONFIG = DOTFILES / "user"


def set_keyboard_layout():
    """X11 persistent keyboard layout."""
    shell.run(["/usr/bin/localectl", "set-x11-keymap", "latam"], stdout=shell.DEVNULL)


def set_theme():
    default_icons = Path.home() / ".icons" / "default"
    symlink_config(USER_CONFIG / ".icons" / "default", default_icons)

    repos_dir = Path.home() / "repos"
    repos_dir.mkdir(exist_ok=True)

    cursors_repo_url = "https://github.com/vinceliuice/Qogir-icon-theme"
    cloned_repo = shell.run(
        ["/usr/bin/git", "clone", "-q", cursors_repo_url, f"{repos_dir}/Qogir-icon-theme"],
        capture_output=True,
        encoding="utf-8",
    )

    local_icons = Path.home() / ".local" / "share" / "icons"
    local_icons.mkdir(parents=True, exist_ok=True)

    if cloned_repo.returncode == 0:
        shell.run([f"{repos_dir}/Qogir-icon-theme/src/cursors/install.sh"], stdout=shell.DEVNULL)
        handle_symlink(local_icons / "Qogir-cursors" / "cursors", default_icons / "cursors")
    else:
        print(
            f"Cursor theme {cursors_repo_url!r} couldn't be installed"
            f" due to the following error {cloned_repo.stderr.strip()!r}"
        )


def git_config():
    home = Path.home()
    completion = Path("/usr/share/git/completion/git-completion.bash")
    if completion.exists():
        shutil.copy(completion, home)

    prompt = Path("/usr/share/git/completion/git-prompt.sh")
    if prompt.exists():
        shutil.copy(prompt, home)

    shell.run(
        ["/usr/bin/git", "config", "--global", "core.excludesfile", f"{home}/.gitignore_global"],
        stdout=shell.DEVNULL,
    )


def make_special_dirs():
    directories = [
        "projects",
        "archives",
        "bin",
        "builds",
        "Documents",
        "Downloads",
        "Images",
    ]
    paths = (Path.home() / dir for dir in directories)
    for path in paths:
        path.mkdir(parents=True, exist_ok=True)


# TODO: Maybe add a summary of the actions made by the script?
# TODO: Add set up for poetry (install with pipx and generate bash completion)
def main() -> int:
    parser = argparse.ArgumentParser(description="For installing user related configuration files.")
    parser.add_argument("--all", action="store_true", help="install everything")
    parser.add_argument("--nvim", action="store_true", help="install Neovim configuration")
    parser.add_argument("--config", action="store_true", help="install '.config/' configurations")
    parser.add_argument("--home", action="store_true", help="install '~/' configurations")
    parser.add_argument("--scripts", action="store_true", help="install local scripts")
    parser.add_argument("--theme", action="store_true", help="install GUI theme")
    args = parser.parse_args()

    if not any(vars(args).values()):
        parser.error("Please choose at least one option")

    if args.all:
        make_special_dirs()
        symlink_config(USER_CONFIG / "home", Path.home())
        symlink_config(USER_CONFIG / ".config", use_dir_name=True)
        symlink_config(USER_CONFIG / ".local", use_dir_name=True)
        git_config()
        set_theme()
        set_keyboard_layout()
    else:
        if args.config:
            symlink_config(USER_CONFIG / ".config", use_dir_name=True)
        if args.nvim and not args.config:
            xdg_config = Path.home() / ".config"
            xdg_config.mkdir(exist_ok=True)
            handle_symlink(USER_CONFIG / ".config" / "nvim", xdg_config / "nvim")
        if args.home:
            symlink_config(USER_CONFIG / "home", Path.home())
            git_config()
        if args.scripts:
            symlink_config(USER_CONFIG / ".local", use_dir_name=True)
        if args.theme:
            set_theme()

    return 0


if __name__ == "__main__":
    sys.exit(main())
