# tmux | Terminal Multiplexer

> Check [tmux documentation](https://github.com/tmux/tmux/wiki/Getting-Started)

- [Keybinds](#keybinds)
- [Command Line Arguments](#command-line-arguments)

## Configuration

Configuration file should either be:

```sh
~/tmux.conf
# or
~/.config/tmux/tmux.conf
```

For setting an option, use `set -g`, this will set the option globally for all sessions, windows and panes.

## Keybinds

Some terminology:

- `M`: Stands for the *Meta* key (normally the `alt` key).
- `C`: Stands for the `ctrl` or *Control* key.
- `S`: Stands for the `shift`key.
- `<prefix>`: Represents the *prefix key*, is the key that should be pressed before any key bind.
By default is `C-b` but it can be change in the settings.


The key binds:

- General use
    - `<prefix> ?`: List all keys and their functionality.
    - `<prefix> d`: Detach from tmux.

- Windows
    - `<prefix> c`: Create a new window.
    - `<prefix> ,`: Rename current window.
    - `<prefix> <idx>`: Switch to the window with the index *idx*.
    - `<prefix> n`: Change to **n**ext window (by index).
    - `<prefix> p`: Change to **p**revious window (by index).
    - `<prefix> l`: Change to **l**ast current window.

- Tree mode
    - `<prefix> s`: Opens tree mode with only sessions.
    - `<prefix> w`: Opens tree mode with sessions and windows.



## Command line arguments

Create a new session with a name:

    $ tmux new -s <session-name>

Do the same, but also assign a name to the first window

    $ tmux new -s <session-name> -n <window-name>

To attach to the last session:

    $ tmux attach

Or attach to a specific session:

    $ tmux attach -t <session>

List available sessions:

    $ tmux ls
