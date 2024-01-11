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

DOTFILES_ROOT = Path(__file__).resolve().parent.parent
USER_CONFIG = DOTFILES_ROOT / "user"


def set_keyboard_layout():
    """X11 persistent keyboard layout."""
    shell.run(["/usr/bin/localectl", "set-x11-keymap", "latam"], stdout=shell.DEVNULL)


def set_theme():
    default_icons = Path.home() / ".icons" / "default"
    symlink_config(USER_CONFIG / ".icons" / "default", default_icons)

    repos_dir = Path.home() / "repos"
    local_icons = Path.home() / ".local" / "share" / "icons"
    repos_dir.mkdir(exist_ok=True)
    local_icons.mkdir(parents=True, exist_ok=True)

    cursors_repo_url = "https://github.com/vinceliuice/Qogir-icon-theme"
    cloned_repo = shell.run(
        ["/usr/bin/git", "clone", "-q", cursors_repo_url, f"{repos_dir}/Qogir-icon-theme"],
        capture_output=True,
        encoding="utf-8",
    )

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
        ["git", "config", "--global", "core.excludesfile", f"{home}/.gitignore_global"],
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


def is_empty_directory(path: Path) -> bool:
    return sum(1 for _ in path.iterdir()) == 0


def handle_symlink(target: Path, destination: Path) -> None:
    assert destination.is_absolute(), "Destination must be an absolute path"

    if not destination.exists():
        destination.symlink_to(target)
        return
    if destination.is_symlink() and destination.readlink() == target:
        return

    home_dest = str(destination).replace(str(Path.home()), "~")

    if input(f"{home_dest!r} already exists, override? [y/N] ").lower() in ("y", "yes"):
        if destination.is_symlink() or destination.is_file():
            destination.unlink()
        elif destination.is_dir() and is_empty_directory(destination):
            destination.rmdir()
        else:
            print(f"==> Could not remove {home_dest!r}, skiping...", file=sys.stderr)
            return
        destination.symlink_to(target)


def symlink_config(config: Path, destination: Path | None = None, use_dir_name: bool = False):
    """Create the symbolic links for the files/directories under the `config` directory.

    `destination`: an explicit folder destination for the config files
    `use_dir_name`: if True, use the name of the `config` directory as the destination
    """
    assert config.is_dir()

    if use_dir_name:
        destination = Path.home() / config.name
    elif destination is None:
        raise ValueError("'destination' should be provided when 'use_dir_name' is False")

    assert destination.is_dir()
    destination.mkdir(exist_ok=True, parents=True)

    for file in config.iterdir():
        handle_symlink(file, destination / file.name)


# TODO: Maybe add a summary of the actions made by the script?
# TODO: Add set up for poetry (install with pipx and generate bash completion)
def main() -> int:
    parser = argparse.ArgumentParser(description="For installing user related configuration files.")
    parser.add_argument("--all", action="store_true", help="Install everything")
    parser.add_argument("--nvim", action="store_true", help="Install Neovim configuration")
    parser.add_argument("--config", action="store_true", help="Install '.config/' configurations")
    parser.add_argument("--home", action="store_true", help="Install '~/' configurations")
    parser.add_argument("--scripts", action="store_true", help="Install local scripts")
    parser.add_argument("--theme", action="store_true", help="Install GUI theme")
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
