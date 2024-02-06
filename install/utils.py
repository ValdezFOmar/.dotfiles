import sys
from pathlib import Path

DOTFILES = Path(__file__).resolve().parent.parent


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
    answer = input(f"{home_dest!r} already exists, override? [y/N] ")

    if answer.strip().lower() not in ("y", "yes"):
        return

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
