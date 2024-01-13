# General tips


## Git

### Branchs

Delete local branch

```sh
git branch -d <branch-name>
```

Delete remote branch

```sh
git push -d origin <remote-branch-name>
```


## Keyboard Configuration

### Temporal

To see a full list of keyboard models, layouts, variants and options for X11, along with a short description,
do the following:

```sh
less /usr/share/X11/xkb/rules/base.lst
```

To set up the configuration, use the following commands:

> [X11 Keyboard config](https://wiki.archlinux.org/title/Xorg/Keyboard_configuration)

```sh
setxkbmap -model xkb_model
setxkbmap -layout xkb_layout
setxkbmap -variant xkb_variant
setxkbmap -option xkb_options
```

> For latin american keyboard layout use: `setxkbmap -layout latam`.

### Persistent

For a persisten keyboard layout configuration use this command instead (reboot to see changes):

```sh
localectl set-x11-keymap skb_layout
```

> The same layouts from `setxkbmap` apply.


## Reload Xresources Configuration

To reload the `~/.Xresources` configuration file, do:

```sh
xrdb ~/.Xresources
```


## Clipboard

Use `gpaste` to manage the clipboard contents. CLI client:

```sh
gpaste-client -h
```

Paste output of command `foo` to `gpaste`:

```sh
foo | gpaste-client
```

> Use the keybind `mod4 + T + H` from the Qtile custom config to see the clipboard history.


## Image Viewer

See images in a directory by `cd`'ing into it and typing:

```sh
nsxiv .
```
