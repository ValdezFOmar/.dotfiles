# General tips

## Reload Xresources Configuration
To reload the `~/.Xresources` configuration file, do:

    xrdb ~/.Xresources

## Change cursor

After downloading and extracting the cursor theme, copy its contents to:

    ~/.local/share/icons

Then to select it as the current cursor theme, launch `lxappearance` and apply the theme.
Finally, to have it automatically be set up at loging, simply symlink the `cursors` directory
from the cursors' theme directory to `~/.icons/default/cursors`. An example might be:

```sh
ln -s ~/.local/share/icons/[theme_name]/cursors ~/.icons/default/cursors
```

## Color picker

To select a color with a color picker use:

    xcolor


## Clipboard

Use `gpaste` to manage the clipboard contents.

cli client:

    gpaste-client -h

paste output of command `foo` to `gpaste`:

    foo | gpaste-client


Or use the keybind `mod4 + T + C` from Qtile custom config.


## Image Viewer

See images in a directory by `cd`'ing into it and typing:

    nsxiv . &


## Auto monitor layout

Use `autorandr` for configuring multimonitors, use the
following options:

> You still need to preconfigured the displays with `xrandr`
and then saved them with `autorandr`

- `autorandr --save <config-name>` For saving the current configuration
- `autorandr --default <config-name>` For making a configuration default when not other is detected

> this overrides the default behavior that makes `autorandr` keep the current
configuration even when monitors are connected/disconnected

# Git

Delete local branch

    git branch -d <branch-name>

Delete remote branch

    git push -d origin <remote-branch-name>
