import enum
import shutil
import sys
from collections import Counter
from pathlib import Path

DOTFILES = Path(__file__).resolve().parent.parent


class TermColor(enum.StrEnum):
    NORMAL = '\033[0m'
    RED = '\033[31m'
    GREEN = '\033[32m'
    ORANGE = '\033[33m'
    BLUE = '\033[34m'
    PURPLE = '\033[35m'
    CYAN = '\033[36m'


@enum.unique
class FileOperation(enum.Enum):
    ERROR = 0, TermColor.RED
    OVERWRITE = 1, TermColor.ORANGE
    COPY = 2, TermColor.PURPLE
    SYMLINK = 3, TermColor.GREEN
    ALREADY_EXISTS = 4, TermColor.BLUE
    SKIP = 5, TermColor.CYAN

    def __init__(self, value: int, color: str) -> None:
        self.severity = value
        self.color = color


class FilesManager:
    _operation_to_message = {
        FileOperation.ERROR: 'error(s) reported',
        FileOperation.OVERWRITE: 'file(s) overwritten',
        FileOperation.COPY: 'file(s) copied',
        FileOperation.SYMLINK: 'symbolic link(s) created',
        FileOperation.ALREADY_EXISTS: 'file(s) already existed',
        FileOperation.SKIP: 'file(s) skipped',
    }

    def __init__(self) -> None:
        self._operations_count = Counter[FileOperation]()
        self._errors: list[str] = []

    def _count_result(self, result: FileOperation) -> None:
        self._operations_count.update((result,))

    def _record_error(self, message: str) -> None:
        self._count_result(FileOperation.ERROR)
        self._errors.append(message)

    def print_summary(self) -> None:
        operation_counts = sorted(self._operations_count.items(), key=lambda op: op[0].severity)
        for operation, count in operation_counts:
            if not count:
                continue
            message = self._operation_to_message[operation]
            print(f'{operation.color}-> {count} {message}{TermColor.NORMAL}')
        for error in self._errors:
            print(TermColor.RED + '==>' + error + TermColor.NORMAL, file=sys.stderr)

    def copy_file(self, source: Path, destination: Path) -> Path:
        """Copy the file and return the path to the created file"""
        path = Path(shutil.copy(source, destination))
        self._count_result(FileOperation.COPY)
        return path

    def create_directory(self, path: Path) -> bool:
        """Try to create a directory"""
        try:
            path.mkdir(exist_ok=True, parents=True)
        except FileExistsError:
            self._record_error(f"'{path}' exists and is a file, not a directory")
            return False
        return True

    def symlink_contents(
        self, directory: Path, destination: Path | None = None, use_dir_name: bool = False
    ) -> None:
        """
        Create symbolic links for the files/directories under `directory`.

        `destination`: an explicit folder destination for the config files
        `use_dir_name`: if True, use `~` + the name of `directory` as the destination
        """
        if not directory.is_dir():
            self._record_error(f"'{directory}' is not a directory")
            return

        if use_dir_name:
            destination = Path.home() / directory.name
        elif destination is None:
            self._record_error(f"'{directory}' no destination was provided")
            return

        if not self.create_directory(destination):
            return

        for file in directory.iterdir():
            self.handle_symlink(file, destination / file.name)

    def handle_symlink(self, target: Path, destination: Path) -> None:
        """Try to create a symlink. If destination is a directory with contents then is skipped."""
        if not destination.is_absolute():
            self._record_error(f"'{destination}' is not an absolute path")

        if not destination.exists():
            destination.symlink_to(target)
            self._count_result(FileOperation.SYMLINK)
            return
        if destination.is_symlink() and destination.readlink() == target:
            self._count_result(FileOperation.ALREADY_EXISTS)
            return

        home_dest = str(destination).replace(str(Path.home()), '~')
        if not prompt_user(f"{home_dest!r} already exists, overwrite?"):
            self._count_result(FileOperation.SKIP)
            return

        if destination.is_symlink() or destination.is_file():
            destination.unlink()
            destination.symlink_to(target)
            self._count_result(FileOperation.SYMLINK)
        elif destination.is_dir() and is_empty_directory(destination):
            destination.rmdir()
            destination.symlink_to(target)
            self._count_result(FileOperation.SYMLINK)
        else:
            self._record_error(f'{home_dest!r} could not be overwritten [possibly a directory with contents]')


def is_empty_directory(path: Path) -> bool:
    try:
        next(path.iterdir())
    except StopIteration:
        return True
    except NotADirectoryError:
        return False
    else:
        return False


def prompt_user(prompt: str) -> bool:
    positive_answers = ('yes', 'y')
    negative_answers = ('no', 'n')
    while True:
        try:
            answer = input(prompt + ' [y/n]').strip().lower()
        except EOFError:
            return False
        if answer in positive_answers:
            return True
        if answer in negative_answers:
            return False
        print(f'{TermColor.ORANGE}{answer!r} is not a valid answer{TermColor.NORMAL}')
