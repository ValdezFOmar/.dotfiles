# General tips

## Links

- [LaTeX Short Guide](https://github.com/oetiker/lshort)

## MISC

- After every kernel update (`linux` package) reboot the system so the
  new kernel modules for hardware are loaded (e.g. USB drives)

## Neovim

### `LuaLS` break

When there's an update to `lua_ls`, mason might brake with a message saying that
the entries in `ensured_installed` are not valid. To solve this, comment out all the options in
`ensure installed`, restart neovim, update with `:MasonUpdate` then you can uncomment
the servers and restart neovim.

### Test a local language server

```lua
require('lspconfig').some_server.setup {
    cmd = { '/path/to/some_server', 'some-arg' }
}
```

## BASH Escape Sequences

Replace color codes with the following syntax. `setaf` stands for '**set** **A**NSI **f**oreground'.
This syntax can only be embedded in double quotes. Also note that `$` need to be escaped for commands
and variables that are intended to be evaluated each time the prompt is printed, else they would
only be evaluated the first time.

```sh
# Here a 'number' can be any in the range of 0 to 15
# use `tput sgr 0` to reset all the properties
color="\[$(tput setaf number)\]"

# Escape '$' by placing a '\' before it
PS1="$color \$(date +%M:%S) $ "
```
Variables that contain escapes (`\[` and `\]`) will not properly escape the
ANSI escape code in `PS1` when:

- use inside literal strings (single quotes `''`)
- it's escaped (`\$`) inside a double quoted string
- it's escaped inside a literal string (it will just print the literal variable name)

## Firefox

To make windows from external links open in tabs instead, apply the changes listed in this
[article](https://support.mozilla.org/en-US/questions/1193456).

## Pacman

- To enable colored output, edit `/etc/pacman.conf` and uncomment the `Color` option.

## Git

### Branches

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

For a persistent keyboard layout configuration use this command instead (reboot to see changes):

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

> Use the key bind `mod4 + T + H` from the Qtile custom config to see the clipboard history.


## Image Viewer

See images in a directory by moving into it and typing:

```sh
nsxiv .
```
