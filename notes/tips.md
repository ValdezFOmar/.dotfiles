# General tips

## Color picker

To select a color with a color picker use:

    xcolor


## Clipboard

Use `gpaste` to manage the clipboard contents.

cli client:

    gpaste-client -h

paste output of command `foo` to `gpaste`:

    foo | gpaste


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
